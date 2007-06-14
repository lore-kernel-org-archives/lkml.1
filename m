Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXFNKmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXFNKmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXFNKmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:42:31 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:27379 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXFNKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:42:30 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: IBM
Date: Thu, 14 Jun 2007 12:38:53 +0200
Message-Id: <1181817533.10064.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 11:41 +0200, Jan Kara wrote:
>   <snip>
> 
> > Your proposal is similar to one I made to some Japanese developers
> > earlier this year.  I was more modest, proposing that we
> > 
> > - add an enhanced printk
> > 
> > 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
>   Maybe a stupid idea but why do we want to assign these numbers by hand?
> I can imagine it could introduce collisions when merging tons of patches
> with new messages... Wouldn't it be better to compute say, 8-byte hash
> from the message and use it as it's identifier? We could do this
> automagically at compile time.

Of course automatically generated message numbers would be great and
something like:

hub.4a5bcd77: Detected some problem.

looks acceptable for me.

We could generate the hash using the format string of the printk. Since
we specify the format string also in KMSG_DOC, the hash for the
KMSG_DOC and the printk should match and we have the required link
between printk and description.

So technically that's probably doable.

Problems are:

* hashes are not unique
* We need an additional preprocessor step
* The might be people, who find 8 character hash values ugly in printks

The big advantage is, that we do not need to maintain message numbers.

> I know it also has it's problems - you
> fix a spelling and the message gets a different id and you have to
> update translation/documentation catalogue but maybe that could be
> solved too...

Since in our approach the message catalog is created automatically for
exactly one kernel and the message catalog belongs therefore to exactly
one kernel, I think the problem of changing error numbers is not too
big.

Michael

