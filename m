Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYH1SYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYH1SYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYH1SYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:24:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53081 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbYH1SYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:24:06 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <48B6EBBD.6050406@kernel.org> (message from Tejun Heo on Thu, 28
	Aug 2008 20:17:33 +0200)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org>
Message-Id: <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 20:23:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Tejun Heo wrote:
> Miklos Szeredi wrote:
> >> If you're worried about the double copying due to performance reasons,
> >> what we can do is implementing userspace to userspace copying.  I just
> >> took easier path of copying twice as u-u copy can't be done using the
> >> existing FUSE mechanics.
> > 
> > How about not copying anything in the kernel, just passing the virtual
> > address to the filesystem?  It can get/modify the data of the calling
> > task by mapping /proc/pid/mem.  Ugly, yes, but ioctls are inherently
> > ugly.
> 
> Hmmm... I was trying to stay within similar operation mechanics as other
> ops.  Directly accessing the caller's memory has performance benefits
> but that benefit can also be used by reads and writes.  So, if we're
> gonna do direct memory access, maybe doing it in more generic way is a
> better idea?

On the contrary: playing VM games is going to be slow.  I think this
approach is best suited for generic ioctl support because it
simplifies the kernel part.  I'd hate to add all that complexity to
the kernel if not absolutely necessary.

Miklos
