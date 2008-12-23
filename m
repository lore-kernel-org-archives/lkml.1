Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYLWV7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYLWV7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLWV7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:59:41 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54534 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYLWV7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:59:39 -0500
Date: Tue, 23 Dec 2008 13:59:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org, ralf@linux-mips.org, kernel@wantstofly.org,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from
	CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081223215948.GA16137@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223142542.GC29151@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 03:25:42PM +0100, Ingo Molnar wrote:
> 
> * paulmck@linux.vnet.ibm.com <paulmck@linux.vnet.ibm.com> wrote:
> 
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Only for testing in -tip and -next, not yet for inclusion into mainline.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  arch/arm/configs/afeb9260_defconfig     |    2 +-
> >  arch/arm/configs/am200epdkit_defconfig  |    2 +-
> >  arch/arm/configs/cm_x300_defconfig      |    2 +-
> >  arch/arm/configs/corgi_defconfig        |    2 +-
> >  arch/arm/configs/csb637_defconfig       |    2 +-
> >  arch/arm/configs/eseries_pxa_defconfig  |    2 +-
> >  arch/arm/configs/ezx_defconfig          |    2 +-
> >  arch/arm/configs/imx27ads_defconfig     |    2 +-
> >  arch/arm/configs/jornada720_defconfig   |    2 +-
> >  arch/arm/configs/kirkwood_defconfig     |    2 +-
> >  arch/arm/configs/loki_defconfig         |    2 +-
> >  arch/arm/configs/magician_defconfig     |    2 +-
> >  arch/arm/configs/mv78xx0_defconfig      |    2 +-
> >  arch/arm/configs/mx31ads_defconfig      |    2 +-
> >  arch/arm/configs/mx31litekit_defconfig  |    2 +-
> >  arch/arm/configs/omap3_beagle_defconfig |    2 +-
> >  arch/arm/configs/omap_h2_1610_defconfig |    2 +-
> >  arch/arm/configs/omap_ldp_defconfig     |    2 +-
> >  arch/arm/configs/orion5x_defconfig      |    2 +-
> >  arch/arm/configs/overo_defconfig        |    2 +-
> >  arch/arm/configs/palmz72_defconfig      |    2 +-
> >  arch/arm/configs/pcm037_defconfig       |    2 +-
> >  arch/arm/configs/pcm038_defconfig       |    2 +-
> >  arch/arm/configs/s3c2410_defconfig      |    2 +-
> >  arch/arm/configs/spitz_defconfig        |    2 +-
> >  arch/arm/configs/tct_hammer_defconfig   |    2 +-
> >  arch/arm/configs/viper_defconfig        |    2 +-
> >  arch/arm/configs/xm_x2xx_defconfig      |    2 +-
> >  28 files changed, 28 insertions(+), 28 deletions(-)
> 
> ouch!
> 
> There's a much more shrewd method to achieve the same, via 2 lines total 
> patch:
> 
> Change the name of CONFIG_CLASSIC_RCU to something else such as 
> CONFIG_FLAT_RCU. That does all the magic and more: all configs will 
> default to tree-rcu - not just defconfigs! Agreed?

Good point!

> [ I think the gene of laziness is probably more developed in my genome
>   than in yours. It is a very useful trait ;-) ]

Lazy or not, your approach is much better than what I was doing.  ;-)

Two patches in subsequent emails: the first gets rid of a duplicate
RCU_CPU_STALL_DETECTOR config declaration (noticed in this exercise --
one each from the CLASSIC_RCU and TREE_RCU stall detectors), and the
second changes the default to TREE_RCU as you suggest.

							Thanx, Paul
