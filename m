Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYKMLaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYKMLaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYKML3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:29:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:50038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYKML3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:29:51 -0500
Message-ID: <491C0FA0.5070500@kernel.org>
Date: Thu, 13 Nov 2008 20:29:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <491BC3E3.7040903@kernel.org> <E1L0aEn-0006dh-BK@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L0aEn-0006dh-BK@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 11:29:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
> Not with '-oallow_other'.  Consider the case that the caller invoked a
> non well formed ioctl, but since there's no way to know this we
> allowed the fuse server to tinker with the caller's address space
> _as if_ the ioctl was well formed.

Right, allow_other.

> So we should always make sure that the server has enough privilege to
> read/write the caller's memory, i.e. it can ptrace the caller.
> 
> At this point we could allow any ioctls, not just well formed ones.
> But I don't want that for a different reason: if the possibility is
> there people will find new "innovative" uses for it and just get
> themselves into a big mess.

I don't really mind people doing strange things in userland as long as
it's safe but you're the maintainer.  It's a bit strange to export the
feature only for CUSE, so I'm a little bit hesitant.  I wanna make it
useful for both.  So, at the kernel level, only well formed for FUSE and
everything goes for CUSE.  Does that sound good enough?

-- 
tejun
