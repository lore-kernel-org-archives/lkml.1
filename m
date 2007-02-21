Return-Path: <linux-kernel-owner+w=401wt.eu-S1423262AbXBUWys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423262AbXBUWys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423260AbXBUWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:54:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423258AbXBUWyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:54:46 -0500
Date: Wed, 21 Feb 2007 14:54:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat
 doing ftruncate
Message-Id: <20070221145419.2f783dc3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0702211644170.3435-100000@iolanthe.rowland.org>
References: <20070221133112.aec2bdac.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0702211644170.3435-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 16:50:23 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > +	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
> 
> Is that really the correct test?  I don't know enough about the memory 
> management subsystem to say one way or the other.  What's special about 
> having both flags set?

yup.  We're saying "if the caller is unable to take either IO locks or FS
locks, don't wait on FS or IO completion".

ie: don't wait on writeout progress unless we know that both the IO system
and the FS are able to make progress.
