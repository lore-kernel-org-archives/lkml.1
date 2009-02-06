Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZBFXEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZBFXEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZBFXEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:04:21 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:39532 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZBFXEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:04:20 -0500
Date: Fri, 6 Feb 2009 16:04:18 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 11/11] Fix omap1 clock issues
In-Reply-To: <20090206214450.GN13758@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902061447430.26737@utopia.booyaka.com>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191844.16688.39372.stgit@localhost.localdomain> <20090129143733.GB18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902061417390.26737@utopia.booyaka.com>
 <20090206214450.GN13758@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Fri, 6 Feb 2009, Russell King - ARM Linux wrote:

> On Fri, Feb 06, 2009 at 02:19:34PM -0700, Paul Walmsley wrote:
> > [paul@pwsan.com: This patch has been updated to use offsets for OMAP1 
> > clock enable registers, to resolve all current sparse warnings with the 
> > clock code, and to convert most magic constants into symbolic macros.  
> 
> Wish you hadn't;

If it's the patch that is problematic, I'm certainly open to comments to 
revise it.

As you've probably seen, the OMAP1 clock control registers and memory map 
are structured quite differently than the OMAP2/3 PRCM and module layout.

> I've been avoiding the patches changing the way registers
> are accessed for the time being - until I have an opportunity to think
> about them for a bit.
>
> As can be seen in the OMAP2 updates, this approach causes additional 
> struct clk's to appear for mcbsp clocks because they have controlling 
> registers split across two subsystems.  This is contary to one of your 
> other statements about wanting the struct clk's to reflect the real 
> clock structure without virtual clocks.

I think we're just using the term "virtual clock" differently.

"Virtual clocks" in my usage are clocks that have no direct connection to 
a particular clock tree entity in the hardware, such as a gate, divider, 
source multiplexer, or oscillator source.  Examples of these virtual 
clocks are those that were created simply for convenience to switch a 
group of hardware clocks on and off (as the old McBSP clocks were).

In the medium-term, the plan here is to modify the OMAP clk_set_parent() 
and clk_set_rate() functions to walk up the clock tree if the device 
driver-supplied clock does not support parent/rate selection.  This is a 
relatively minor fix that should make parent and rate selection 
transparent for device drivers (e.g., drivers shouldn't need 
clk_get_parent() at that point).


- Paul
