Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYAMRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYAMRpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYAMRpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:45:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37667 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753184AbYAMRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:45:21 -0500
Date: Sun, 13 Jan 2008 17:41:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
In-Reply-To: <20080113171916.GB4132@ucw.cz>
References: <200801090022.55589.a1426z@gawab.com>
	<200801090740.12989.a1426z@gawab.com>
	<70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	<200801091452.14890.a1426z@gawab.com>
	<20080112145140.GB6751@mit.edu>
	<20080113171916.GB4132@ucw.cz>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What are ext3 expectations of disk (is there doc somewhere)? For
> example... if disk does not lie, but powerfail during write damages
> the sector -- is ext3 still going to work properly?

Nope. However the few disks that did this rapidly got firmware updates
because there are other OS's that can't cope.

> If disk does not lie, but powerfail during write may cause random
> numbers to be returned on read -- can fsck handle that?

most of the time. and fsck knows about writing sectors to remove read
errors in metadata blocks.

> What abou disk that kills 5 sectors around sector being written during
> powerfail; can ext3 survive that?

generally. Note btw that for added fun there is nothing that guarantees
the blocks around a block on the media are sequentially numbered. The
usually are but you never know.

Alan
