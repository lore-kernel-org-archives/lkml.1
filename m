Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZBCJpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZBCJpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZBCJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:45:34 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:40620 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZBCJpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:45:33 -0500
Date: Tue, 3 Feb 2009 02:45:31 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       tuukka.tikkanen@nokia.com, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code
 up to plat-omap/clock.c
In-Reply-To: <20090131114014.GD1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902030114530.5741@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain> <20090129174153.GH18233@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com> <20090130085249.GB6864@n2100.arm.linux.org.uk>
 <13B9B4C6EF24D648824FF11BE89671620376DEC116@dlee02.ent.ti.com> <20090131114014.GD1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Fri, Jan 30, 2009 at 08:23:49AM -0600, Woodruff, Richard wrote:
> > 
> > > There's one bug that your version highlights in mine - the virtual mpu
> > > clock in omap1 touches the DPLL and repropagates that rate.  I've
> > > removed that repropagation, so that needs fixing.
> > >
> > > However, this raises a question: why is the virtual mpu clock touching
> > > some other part of the clock tree.  I wonder whether this should be
> > > handled a different way, though the first thing that needs answering is
> > > why we have this alias for 'arm_ck' ?
> > 
> > At one point in time the virtual clock allowed control for a set of clocks
> > with some dependencies.  The mpu alias provided a convenient control point.
> 
> >From what I can see (checking both mainline and Tony's tree), this mpu
> alias (virtual_ck_mpu) is not used on OMAP1, which seems to suggest
> that this quirk has become redundant.  If it is redundant, it should
> be removed.
> 
> If there is some code somewhere to use it, this quirk should live with
> the user of the quirk until such time that the user becomes ready to be
> merged.

It was probably an OMAP1 implementation of OPPs, similar to virt_prcm_set 
on OMAP2.  Looks like the tree is missing a CPUFreq driver that uses it.  
Cc'ing Tuukka in case he recalls.

One fix that might solve your particular problem would be to remove the 
parent clock pointer from virtual_ck_mpu.  Neither virtual_ck_mpu or 
virt_prcm_set should need it.


- Paul
