Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYFBT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYFBT5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYFBT50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:57:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52704 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbYFBT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:57:25 -0400
Date: Mon, 2 Jun 2008 20:41:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Xiaoming Li" <forrubm2@gmail.com>
Cc: "Rik van Riel" <riel@redhat.com>, "Dave Chinner" <david@fromorbit.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical
 volume manager as a virtual device driver when physical spaces run out?
Message-ID: <20080602204138.4e198ffd@core>
In-Reply-To: <5f7c1d2c0806021022t67d07733p47b78d351dcf63b6@mail.gmail.com>
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
	<20080529113159.113a7f06@core>
	<5f7c1d2c0806021022t67d07733p47b78d351dcf63b6@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I want to ask, is there _any need_ to implement "Thin
> Provioning" on block level rather than FS level?

A good question

> In my opinon, there are some reasons why we implemented "Thin
> Provioning" on block level:
> 1. We can use _all_ types of FS on our ASD device.

Except that you can run out of space and die.

> 2. In our current system, we use some other virtual device drivers to
> provide other features, like snapshot, cahce management, exporting as
> an iSCSI target in a SAN, etc. Please note, all of these virtual
> device drivers have been developed already.

A cluster file system can do cache management and in theory snapshots.
The iscsi larget is a block property - the equivalence in fs layer would
I guess be NFS. Most of those have been developed too ;)

> 3. Some storage vendors (e.g. EMC) have their own "Block-based thin
> provisioning" product; they must have enough reasons to do so.

Some storage vendors do the most marvellously bizzare things. That
doesn't mean they are right answers. EMC don't/didn't have a cluster file
system so that rather limited their choice.

I think you missed one however and maybe one EMC considered - its a much
easier way to do cross platform non shared filestore as a device than add
clustering file systems to do that.

However if you overcommit you have a problem. Its interesting as a front
end technology with an array of slow large disks behind it (so you don't
overcommit but push old storage to the slow disks). I don't think its
interesting in the general case except where you can carefully avoid
overcommit by management policies.

Its also not helped by the fact your storage layer needs to understand
the fs's it supports in order to deduce what blocks are free so that it
can recover them.

Alan
