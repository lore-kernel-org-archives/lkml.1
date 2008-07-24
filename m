Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYGXVxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYGXVxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYGXVxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:53:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36592
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYGXVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:53:36 -0400
Date: Thu, 24 Jul 2008 14:53:36 -0700 (PDT)
Message-Id: <20080724.145336.41899163.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
	<1216918371.4524.38.camel@localhost.localdomain>
	<Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Thu, 24 Jul 2008 17:49:14 -0400 (EDT)

> * it is prone to bugs and hard to maintain, because the same value must be 
> calculated in blk-merge.c and in architectural iommu functions --- if the 
> value differs, you create too long request, corrupt kernel memory and 
> crash (happened on sparc64). Anyone changing blk-merge in the future will 
> risk breaking something on the architectures that use BIO_VMERGE_BOUNDARY 
> --- and because these architectures are so rare, the bug will go unnoticed 
> for long time --- like in the case of sparc64.

I completely agree with this point.

This VMERGE stuff is now a non-trivial maintainence burdon because
anyone who wants to hack on the block layer has to be mindful of
VMERGE but is very unlikely to have access to a system that it can
even be tested on.

And the answer isn't "James Bottomly will test your changes for you",
because that simply doesn't scale.

I still say we should definitely remove the VMERGE code.  It's not
worth the maintainence hassle just for some SG chaining test rig
on some obscure platform.

I really only hear one person who really wants this code around any
more.  Is that the Linux way? :-) Can't he patch it into his tree when
he needs it or write an alternative way to stress the SG chaining
code?  He has the source, right? :-)))
