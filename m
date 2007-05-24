Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXEXV4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXEXV4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXEXV4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:56:38 -0400
Received: from mail.suse.de ([195.135.220.2]:59027 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXEXV4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:56:36 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Thu, 24 May 2007 23:56:28 +0200
User-Agent: KMail/1.9.5
Cc: James Morris <jmorris@namei.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200705242010.00961.agruen@suse.de> <20070524184039.GH4095@ftp.linux.org.uk>
In-Reply-To: <20070524184039.GH4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242356.29370.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 20:40, Al Viro wrote:
> On Thu, May 24, 2007 at 08:10:00PM +0200, Andreas Gruenbacher wrote:
> 
> > Read it like this: we don't have a good idea how to support multiple 
> > namespaces so far. Currently, we interpret all pathnames relative to the 
> > namespace a process is in. Confined processes don't have the privilege to 
> > create or manipulate namespaces, which makes this safe. We may find a
> > better future solution.
> 
> You also don't have a solution for multiple chroot jails, since they
> often have the same fs mounted in many places on given box *and* since
> the pathnames from the confined processes' POVs have fsck-all to do
> with each other.
>
> It's really not kinder than multiple namespaces as far as your approach
> is concerned.

Well, the pathnames we check against are namespace relative, so no matter what 
pathnames the chrooted processes think they are looking at, we always know 
the actual pathnames up to ``outside the chroot''. Having the same filesystem 
mounted in multiple chroots or in multiple locations in the same chroot 
doesn't matter.

The main problem I see when it comes to defining per-namespace policy is that 
namespaces are inherently anonymous, and there is no obvious way of 
associating different sets of profiles with different namespaces. 
Implementing something to also handle multiple namespaces doesn't seem 
hard -- after all, it's not such a difficult concept -- but I don't have a 
good enough idea what would work best.

Thanks,
Andreas
