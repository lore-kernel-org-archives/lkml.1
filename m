Return-Path: <linux-kernel-owner+w=401wt.eu-S1161004AbXAaUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161004AbXAaUBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161009AbXAaUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:01:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:50225 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161004AbXAaUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FrSxcNz1jYcelLufvR7LDaxLsYcmGj852BZ07P9B+cAOKBRnHQ6kLJr7+rfpVzgqQvqgzsakIVBPaRmhdEUaxvWtoSAtC7NLqrzVDdE9YH1f7ymjETXc4Agy/EHGmWWnmCSwk2vuO9NsL7CTZAG+po6R9G6UnHyjD0dHepMNSNE=
Message-ID: <f2b55d220701311201o29e2fbaby41862b4804defa69@mail.gmail.com>
Date: Wed, 31 Jan 2007 12:01:18 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <C027A21A-42C4-4901-96F0-82E36CAD6C22@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com>
	 <f2b55d220701301827h703d24eele941c86046caa9e7@mail.gmail.com>
	 <20070131062607.GA14548@kroah.com>
	 <C027A21A-42C4-4901-96F0-82E36CAD6C22@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Kumar Gala <galak@kernel.crashing.org> wrote:
> Out of interest are you was this geared to any particular SoC's/
> architectures?

I had in mind the sort of ARM-, PPC-, and MIPS-based SoCs that wind up
in handhelds, mobiles, set-tops, and consumer-grade WiFi devices.
That's an area I know passably well, having done both Linux-based and
proprietary-OS-based board support for some years, usually in a
"platform integrator" sort of role.

Part of the reason that most software-defined-radio WiFi vendors have
been slow to cooperate with the kernel community is that their driver
code is pretty fragile and blows chunks when poked in unexpected ways.
 This is not surprising, given the way these companies are structured
and the fact that there has been little market pressure to make it
otherwise.  The field support folks may not have the resources or even
the source code necessary to fix the driver, and they often feel like
the only answer is to lock down the rest of the system to limit usage
patterns to those that the driver writer happened to see in his
Faraday cage.

Especially if there's a corner case that sends the RF power open-loop,
they worry that the FCC (or more likely ETSI) will come down on them
for making it too easy for hobbyists to build ISM foghorns with ugly
spurs in licensed spectrum.  If you want vendor participation in
creating open source drivers for these things, I think you have to get
them engaged long before they enter regulatory test, and understand
their damage control requirements, and keep the discourse relatively
private until the go-to-market stage, at which point they've
presumably decided they can brazen out the remaining hack potential.

Another part of the problem is that embedded vendors come from a world
of destructive competition between BSP houses, where "fork, fire, and
forget" is as much a vendor lock-in tactic as a short-term perspective
on cost efficiency.  They've never had the experience of having their
heads knocked together by a purchaser with overwhelming market power
and the technical resources to identify the guilty (as the early 2-D
graphics board vendors did with MIT and the Ethernet folks did with
ARPA).  We tend to take for granted the legacy of interoperability
that comes from such head-knocking-together, especially when a new
generation of vendors doesn't play by the same rules.

In the absence of such a monopsonist, our best bet for encouraging
more openness, and someday even actual participation, from SoC people
may be to help them with the part that they do understand to be sunk
cost rather than competitive asset -- bringup efforts, workarounds for
buggy UARTs and EtherMACs and other bog-standard interfaces, and the
rest of arch/arm/mach-foo (or the MIPS/PPC equivalent).  Mainstream
that, so that their customers can actually evaluate how their
application code behaves on new toolchains and kernels (with stubs in
place of the hairier drivers), and you'll help SoC customers make the
case for open source drivers for the sexier bits.

Needless to say, uniting forces with the upstream maintainers of open
source embedded bootloaders and toolchain / userland build systems
would help too.  After the first six months of freedom from code
reviews, nobody really likes maintaining a fork.  But undoing a fork
can be a lot of work, especially when upstream is picky about code
quality; there has to be some quantifiable benefit to justify it.

In embedded space, power consumption, memory footprint, and maximum
latency are usually where the pain is perceived to be.  Even though it
would probably be more rational to rank interoperability, software
reliability, and portability to the next chip among or above these,
consumer electronics companies rarely think that way.  So if you want
to dangle a carrot in front of SoC vendors, you might try an
integration branch with OpPoint and RT/Preempt patches and guidance on
the CONFIG_EMBEDDED options.

Cheers,
- Michael
