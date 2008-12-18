Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752463AbYLRIT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYLRIT7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYLRITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:19:49 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:20112 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751456AbYLRITs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:19:48 -0500
Date: Thu, 18 Dec 2008 09:19:46 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: FPU emulation broken in 2.6.28-rc8 ?
Message-ID: <20081218081946.GA3879@bitwizard.nl>
References: <20081217085620.GA20184@bitwizard.nl> <20081217203227.GA10899@bitwizard.nl> <878wqe1kvg.fsf@basil.nowhere.org> <20081217225221.GA6247@bitwizard.nl> <20081217233357.GI25779@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217233357.GI25779@one.firstfloor.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 12:33:57AM +0100, Andi Kleen wrote:
> On Wed, Dec 17, 2008 at 11:52:21PM +0100, Rogier Wolff wrote:
> > On Wed, Dec 17, 2008 at 11:45:39PM +0100, Andi Kleen wrote:
> > > Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> > > >> 
> > > >> I'm trying to set up a thin client, which runs on a geode, which
> > > >> apparently doesn't have a FPU.... (/proc/cpuinfo mentions the flag 
> > > >> "fpu", what does THAT mean?)
> > > 
> > > Geodes all have FPUs to my knowledge.
> > > The only FPU less x87s are 386s and special 486s (and a few emulators)
> > > 
> > > If the FPU doesn't work on the Geode something else must be broken
> > > (or your CPU is not really a Geode)
> > 
> > Although the /proc/cpuinfo file shows the FPU flag, the kernel stops
> > with "no fpu found, and math emulation not present" if I disable
> > FP emulation.... 
> 
> As I said then the problem is likely with the FPU check.
> 
> That said I don't doubt that FPU emulation might have broken
> again (that is because hardly anyone uses it), just that fixing
> it is not the real fix for your problem.

In the past, I've compiled kernels with math emulation "just in case". 
That was in that time that if my with-fpu machine would break down, I
might have to put a motherboard without FPU in there, and I liked the
prospect of being able to boot in such a case. 

So, if an FPU is present, the math emulation code should just sit 
dormant. Even when the detection then thinks that no FPU is present, 
the "illegal instruction" traps that the math emulation is based on
simply should not occur.

But even if the math emulation code is actually active, then it should 
simply work, and emulate any FPU instructions without problem. 

	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
