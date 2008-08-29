Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYH2Hcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYH2Hcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYH2Hcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:32:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48851 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYH2Hcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:32:32 -0400
To: hpa@kernel.org
CC: miklos@szeredi.hu, tj@kernel.org, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <48B7183E.3010100@kernel.org> (hpa@kernel.org)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org> <48B6F7C5.3020204@kernel.org> <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu> <48B708C4.4000405@kernel.org> <E1KYoX9-0004Mn-NX@pomaz-ex.szeredi.hu> <48B7183E.3010100@kernel.org>
Message-Id: <E1KYySw-0005RZ-3e@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Aug 2008 09:32:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, H. Peter Anvin wrote:
> Miklos Szeredi wrote:
> > On Thu, 28 Aug 2008, H. Peter Anvin wrote:
> >> This is *hard* to get right, and we screw this up in the kernel with 
> >> painful regularity.  The throught of having user-space processes, which 
> >> don't have access to the kernel locking primitives and functions like 
> >> copy_from_user() dealing with this stuff scares me crazy.
> > 
> > What issues exactly are you thinking of?
> 
> Memory changing underneath you.  It can be dealt with by very careful 
> sequencing only.

That's just handwaving.  Apps don't normally change memory under
system call arguments.  Or if they do the only thing we ever guarantee
is that the thing won't blow up in a big fireball.

I don't see how getting the data from userspace is different from
doing the same in the kernel.  Care to explain?

> >> That is why I'm suggesting using an in-kernel linearizer.
> > 
> > Lots of complexity, ugh...  Even Tejun's current scheme is better IMO.
> 
> And then you get *no* privilege separation, for one thing, so why even 
> bother doing it in userspace?

And with ioctls (at least if the filesystem supplies the linearizer
instructions) you simply _cannot_ get proper privilege separation.
Generic ioctl support will always be a privileged thing.

Alternatively we can restrict ioctls.  Most ioctls conform to some
convention for encoding the format (size/in/out) in the command, no?

Miklos
