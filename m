Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZHYJco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZHYJco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZHYJco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:32:44 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:18447 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754798AbZHYJcl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:32:41 -0400
X-SpamScore: 2
X-BigFish: VPS2(z34a4jz1432R98dN936eMa594izz1202hzz3198u327alz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOXEHG-01-4SN-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 11:31:01 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090825093101.GJ20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251128176.7538.301.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 09:31:01.0639 (UTC) FILETIME=[C2AB7970:01CA2566]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > The correct mask that describes core-siblings of an processor
> > is topology_core_cpumask. See topology adapation patches, especially
> > http://marc.info/?l=linux-kernel&m=124964999608179
> 
> 
> argh, violence, murder kill.. this is the worst possible hack and you're
> extending it :/

So this is the third code area
(besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
that is crap, mess, a hack.

Didn't know that I'd enter such a minefield when touching this code. ;-(

What would be your perferred solution for the
core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
this function?

> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/kernel/smpboot.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index f797214..f39bb2c 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -446,7 +446,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >  	 * And for power savings, we return cpu_core_map
> >  	 */
> >  	if (sched_mc_power_savings || sched_smt_power_savings)
> > -		return cpu_core_mask(cpu);
> > +		return topology_core_cpumask(cpu);
> >  	else
> >  		return c->llc_shared_map;
> >  }
> 

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


