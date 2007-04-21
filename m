Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXDUA13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXDUA13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDUA13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:27:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53508 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXDUA12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:27:28 -0400
Subject: Re: [PATCH] fix ext2 allocator overflows above 31 bit blocks
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
In-Reply-To: <46294967.6070601@redhat.com>
References: <4628F3ED.9040101@redhat.com>
	 <20070420230208.GU5967@schatzie.adilger.int>  <46294967.6070601@redhat.com>
Content-Type: text/plain
Organization: IBM LTC
Date: Fri, 20 Apr 2007 17:27:15 -0700
Message-Id: <1177115236.3778.23.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 18:14 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On Apr 20, 2007  12:10 -0500, Eric Sandeen wrote:
> >> If ext3 can do 16T, ext2 probably should be able to as well.
> >> There are still "int" block containers in the block allocation path
> >> that need to be fixed up.
> > 
> > Yeah, but who wants to do 16TB e2fsck on every boot?  I think there
> > needs to be some limits imposed for the sake of usability.
> 
> I figure this is in the fine tradition of "enough rope to hang oneself"
> 
> If you have 16T of filesystem you probably know enough to not hang 
> yourself this way.
> 
> *shrug*
> 
> It's a bug, today.   

They are fixed in mm tree, as part of the patches which backports ext3
block reservation code to ext2. filesystem block numbers are all
ext2_fsblk_t type(i.e. unsigned long)(see ext2_new_blocks()). Maybe need
a round of thorough review to see if anything left, but I think what in
mm tree looks good.

And those patches in mm tree also backports the ext3 best-effort
allocates multiple blocks code (allocate multiple blocks within the
block reservation window as much as possible), FYI.

Mingming

> If we need another change to limit ext2 to 500G or 
> something, fine by me.  :)
> 
> -Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

