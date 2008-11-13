Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbYKMGGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbYKMGGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 01:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYKMGGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 01:06:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:41356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYKMGGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 01:06:39 -0500
Message-ID: <491BC3E3.7040903@kernel.org>
Date: Thu, 13 Nov 2008 15:06:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org>
In-Reply-To: <491A96AE.3080600@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 06:06:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> I still got qualms about this ioctl thing.  One is the security
>> aspect, but that could be dealt with.  The other is that I really
>> really don't want people to start implementing new custom ioctls for
>> their filesystems, as I think that way lies madness.  We could limit
>> ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
>> we could enforce the "standard" format where the type and length is
>> encoded in the command number.
> 
> For now, I'll limit ioctl to CUSE.  Hmmm... Yeah, limiting ioctl to
> well-formatted ones sounds like a good idea.
> 
>> I don't have any problems with the iterative way you implemented
>> ioctls.  We just need some additional restrictions to the current
>> implementation, I think.

I've been thinking about this a bit more.  What do you think about
putting the following restrictions?

1. FUSE server can only support well-formed ioctls.  At the kernel side,
the interfaces remains the same for both FUSE and CUSE but libfuse only
exports well-formed ioctl API.

2. ioctl can only be used by FUSE server running as root (would this be
necessary?  I'm not sure.  To me it seems all the necessary protections
are already there).

Thanks.

-- 
tejun
