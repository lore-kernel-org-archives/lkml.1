Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0CEAaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:30:05 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39890 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0CEAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QMZAkJQaA6qyujkg14DqOey88inrS4iWrsw9NLqwQBpbeegpi4Zt/VisDfy0pplx49
         YpxMPU6cvZRFlE3uMDV1iMvfa+DHzUfHFCzOSUCdZrykgaoLWdQyOuTFz7YSU7+lEduB
         T+MHbubVpqVeizarykzb2KlnUZi6gJY0fTkdc=
Subject: Re: [git pull] drm request 3
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <20100304103655.0b14343f@jbarnes-piketon>
	 <20100304103929.6eb81d45@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 10:28:47 +1000
Message-ID: <1267748927.3496.6.camel@nisroch>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 (2.29.91-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:08 -0800, Linus Torvalds wrote:
> 
> On Fri, 5 Mar 2010, Dave Airlie wrote:
> > 
> > Speaking as distro maintainer here,
> > 
> > No because we've got versioned interfaces and we are happy to support them
> > yes it would be nice sometimes to dream about this, but its a major explosion in
> > the testing matrix. You have to realise the more codepaths a distro ships, the
> > more codepath it has to keep track off for security issues, for bug fixes, etc.
> 
> I think you're missing the whole point here. There's no new and complex 
> "testing matrix". You only ever test the newest version, so there's no 
> additional testing.
> 
> Here's the "inductive proof":
> 
>  - if the version number doesn't change, you aren't doing anything that is 
>    at all different from what you already do.
> 
>  - if the version number _does_ change, it does so only because you 
>    updated both the kernel component and the libdrm component together, 
>    and you test them together - exactly like you already do.
> 
> So there is absolutely no difference for you. In either case, you only 
> ever test paired up versions. If you make a new version, it will never 
> _ever_ interact with old versions. There's no new complex testing needed.
> 
> The only thing it allows is for you to have multiple kernels installed 
> simultaneously - and be able to _use_ them all. Which is something you 
> already do.
> 
> And which the current model doesn't allow for. You may have three 
> different kernels installed, but if libdrm got updated with a version 
> change, only one of those kernels will actually _work_.
> 
> > When to we decide to stop shipping nouveau_drv-0.0.13? when do we find
> > out it has a security issue?
> 
> Irrelevant and total red herring. You never care about older versions, 
> since if people have updated, they are running the newer version.
> 
> So the older versions are there purely so that you _can_ have multiple 
> different kernels, and so that your _developers_ can compile new kernels 
> for older distributions. They aren't relevant for the case you point to: 
> if somebody is just doing "yum update", they'll get - and use - the newer 
> version anyway.
> 
> > Here's the thing, distros are trying to ship an OS with a consistent set 
> > of packages, not a pick-n-mix.
> 
> But here's the thing: if you expect people to do development, they _need_ 
> to be able to mix things. A kernel developer needs to be able to update 
> their kernel. And a kernel _tester_ needs to be able to test that kernel.
Here's the thing.  *You* pushed for nouveau to go into staging before
any of the developers were ready for it.  Two of the big reasons (from
my POV) for not requesting inclusion were the context programs (which
have since been dealt with) and that yes, we have no intention of
keeping crusty APIs around when they aren't what we require.

The idea of staging was to allow for exactly the second problem, so why
are you surprised?  The fact Fedora ships nouveau is irrelevant, we also
expect that for the most part people will be using our packages, which
deal with the ABI issues.

> 
> Seriously: what do you expect me to do right now in my situation?
> 
> I'm not going to release a kernel that I can't test. So if I can't get a 
> libdrm that works in my F12 environment, I will _have_ to revert that 
> patch that you asked me to merge.
The F13 packages *will* work, so long as you're not bisecting back and
forth.

> 
> Really. Look at it from my standpoint. Look at it from _any_ kernel 
> developer standpoint. It would be totally irresponsible of me to release 
> 2.6.34 without even eating my own dog-food on my own main machine. Can't 
> you see that this is obviously true?
With the release of 2.6.34 it'll require people to update userspace
*once*, if they're rolling their own kernels and not using distro
provided packages they should be able to handle that much.

I agree it's a pain to bisect through, really.  But it's far far from
the common use case.

Ben.

> 
> So right now, I'm running with that patch reverted on that machine. I 
> haven't committed the revert, and quite frankly, I'd really prefer not to. 
> But the only way that "not revert" case can really happen is if there is 
> some other way for me to have a working machine again.
> 
> Think about it. Tell me what the solution is.
> 
> 		Linus
> 
> ------------------------------------------------------------------------------
> Download Intel&#174; Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling, find bugs
> proactively, and fine-tune applications for parallel performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel


