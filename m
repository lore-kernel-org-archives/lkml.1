Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYKLKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYKLKBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYKLKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:01:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53327 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYKLKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:01:11 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491A96AE.3080600@kernel.org> (message from Tejun Heo on Wed, 12
	Nov 2008 17:41:18 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org>
Message-Id: <E1L0CWu-0004Dk-F9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Nov 2008 11:00:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Tejun Heo wrote:
> > Comments about the others:
> > 
> >   0002-FUSE-pass-nonblock-flag-to-client.patch
> > 
> > this is not needed, f_flags are already passed to userspace for read
> > and write.
> 
> Hmmm... I'll try to find out whether I can use f_flags.  There was
> something that prevented it from working properly.  I'll dig.

Support for this was missing from libfuse, but now I fixed that in the
CVS version.

> >   0004-FUSE-implement-direct-lseek-support.patch
> > 
> > this is trickier to get the interface right I think.  If we want to
> > allow filesystems to implement a custom lseek, then we also want them
> > to keep track of the file position, which means we must differentiate
> > between a write(2) and a pwrite(2) and similarly for reads.  AFAICS
> > this isn't needed for CUSE so we can leave this to later.
> 
> Read/write already passes @offset, so the only thing required is an
> extra flag there.  I mainly wanted a way for a CUSE server to veto lseek
> with proper error and still think it's better to have this as we don't
> really know what wacky users are out there.  What do you think about an
> extra flag?

OK, but that's gonna involve a fair bit of API churn, and I'm not sure
it's worth it at this stage.  If this is not needed for the OSS
emulation, I think we should postpone it.

Thanks,
Miklos
