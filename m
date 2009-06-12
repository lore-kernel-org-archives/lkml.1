Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbZFLCQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbZFLCQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbZFLCQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:16:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbZFLCQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:16:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yL8e0s7FoLZtMJbToGcHjOhLVioC4N+swtZEVRYyzLbONGAwzO1eNJV9IMJPdEQ0e
	+7VROtNTn80Lw+by2gqkg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
	 <20090611132134.GA11199@atomide.com>
	 <20090611133736.GP795@n2100.arm.linux.org.uk>
	 <20090611140038.GB11199@atomide.com>
	 <20090611140624.GS795@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
	 <4A3175AC.9070100@bluewatersys.com>
	 <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
	 <4A31AECA.6070303@bluewatersys.com>
	 <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
Date: Thu, 11 Jun 2009 19:16:29 -0700
Message-ID: <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, pavel@ucw.cz,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 6:51 PM, Nicolas Pitre<nico@cam.org> wrote:
> On Fri, 12 Jun 2009, Ryan Mallon wrote:
>> Nicolas Pitre wrote:
>>
>> Thats my point though: In the meantime, it falls on Russell by default
>> to be the one to verify all the patches going through. I think the same
>> is true for new architectures, if nobody else has the interest/hardware
>> besides those posting the patches, then who is meant to do the
>> reviewing/acking?
>
> I think that, at some point, if nobody else has the interest/hardware,
> then you are on your own.  Just make sure that your code respects the
> kernel coding style, has no obvious API misuses, and that it does not
> affect anyone else.  At that point if you can convince people that your
> code is actually useful and that you'll be around to quickly respond
> if/when issues are reported then it should just be merged.

My hope with the msm support is to get buildable, bootable (we're
there now), style-clean (we probably have stuff that needs help yet,
though I think we're improving) support for the platform in the tree
so people can actually build mainline for things like HTC Dream /
Sapphire, Qualcomm's SURF boards, etc.

At that point, I think we'll get more people looking at, testing, and
hopefully contributing and reviewing patches in that domain -- I know
there are a lot of folks out there hacking on ADP1 (the unlocked dev
phone) or "rooted" G1s, and some of them tinker with things at the
kernel level.

>From a practical standpoint, some questions about trying to get a
bunch of msm stuff cleaned up possibly for 2.6.31:
- would having some ifdefs around code using wakelock support be
acceptable for the time being?  The wakelock/suspendblock review does
seem to be making progress on linux-pm if not super quickly, and I'd
rather maintain some ifdefs than maintain two different versions of
drivers while it's getting sorted out.
- from where we are now, with .30 about to be wrapped up, what's the
reasonable timeline for putting together a patch series for mach-msm
and for drivers/staging/msm7k or the like?  When should I be sending
what to where?  Presumably to lakml at the least?
- is it essential to completely flatten down to single patches for new
drivers?  We do have history including contributions from Qualcomm,
HTC, etc, which would be nice to preserve in some cases, but if that's
impractical, we can do a complete rebase and flatten on top of tip of
tree.

I'd love review/feedback on things -- I think, to Alan's original
suggestion, I just would like to avoid ending up in a holding pattern
on getting support for these SoCs and devices into mainline
(especially if we can do it without breaking anybody else).  I do
understand if there aren't a lot of people interested in wading
through the frightening realm of AMSS/QDSP remote interfaces...

Thanks,

Brian
