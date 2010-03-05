Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0CEAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:24:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0CEAYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:24:49 -0500
Date: Thu, 4 Mar 2010 19:24:15 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305002415.GG12443@bombadil.infradead.org>
References: <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain> <20100304195302.GA24856@srcf.ucam.org> <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain> <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com> <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain> <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com> <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain> <alpine.LFD.2.00.1003041522570.3751@localhost.localdomain> <21d7e9971003041535g9dbfe46k67f64aa4219da0b8@mail.gmail.com> <alpine.LFD.2.00.1003041538380.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041538380.3751@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 03:53:32PM -0800, Linus Torvalds wrote:
> Even if Stepane doesn't care, people inside RedHat/Fedora must care. Are 
> you guys simply planning on never supporting F12 with 2.6.34?  I'd expect 
> it to be a _major_ pain to have that whole hardcoded "X and kernel must 
> always change in lockstep".
> 

Frankly, I completely agree with you. This kind of shit makes it
extremely difficult for users to run, say, 2.6.33 on F-12 without us
doing a backport. Thankfully Ben takes care of that for me, usually,
by keeping nouveau up to date with upstream in the various Fedora's, but
it's still a set of shackles that I'm pretty sure none of us want. (Not
only that, but it means if you update, you may need to do a full reboot
before you can start X again, which is pretty disappointing.)

For example, right now, Fedora 11's 2.6.30 kernel has nouveau 12, with
nouveau 12 userspace. For Fedora 11's 2.6.32 kernel, instead of updating
the userspace stuff, I forward ported the old DRM entirely, bringing
with it whatever bugs it had, simply because DRM is such a nightmare.

It's already impossible to run Fedora 13's 2.6.33 kernel on 12 since Ben
put the nouveau git changes for the new ABI in there already. So we'll
have to drop those from the F-13 2.6.33 for the F-12 2.6.33...

This situation /sucks/ for users. Personally, I think we committed to a
stable update ABI when nouveau got a MODULE_DEVICE_TABLE and started
binding by default. But hey, I'm just the kernel maintainer, and I
didn't pipe up then, which was my mistake. If we're going to ram
something at users by default, we should at least try to guarantee that
they'll be able to restart X and have things continue to work.

That said, whether you think it's a lame excuse or not, staging was
clearly labelled as buyer beware.

I'm personally sorry that you got burned by nouveau on Fedora both these
times, but we're really just trying to help, and not hinder things.
(Maybe I should commit a patch to rip out the module aliases for
nouveau, but I suspect I'd have more people screaming for blood that
way. Sigh.)

regards, Kyle
