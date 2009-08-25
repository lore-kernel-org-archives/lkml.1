Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZHYJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZHYJUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZHYJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:20:31 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7201 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZHYJUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:20:30 -0400
X-SpamScore: -20
X-BigFish: VPS-20(z34a4jz154dM1432R98dN936eMa594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOXDXW-01-4FB-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 11:19:41 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] sched: Conditionally limit __cpu_power when
	child sched domain has type NODE
Message-ID: <20090825091941.GI20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134506.GC29327@alberich.amd.com> <1251128132.7538.300.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251128132.7538.300.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 09:19:41.0906 (UTC) FILETIME=[2D847320:01CA2565]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:35:32PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:45 +0200, Andreas Herrmann wrote:
> > We need this in case of performance policy. All sched_groups in
> > child's parent domain (MN in this case) should be limited such that
> > tasks are balanced among these sched_groups.
> 
> /me fails at correlating the above changelog and the below patch.

> So here we go mess up cpu_power again in order to invluence the
> placement policy?

Yep, to restrict the capacity of sched_groups in MN domain.

But you pointed already out that messing up cpu_power is
unwanted.

So I have to look for an alternative to influence placement policy
such that cpu_power is kept intact and always properly normalized.
 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  kernel/sched.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 0c950dc..ab88d88 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -8555,11 +8555,11 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
> >  	 */
> >  	if (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
> >  	    ((child->flags &
> > -	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
> > +	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)) ||
> > +	     (child->level == SD_LV_NODE))) {
> >  		sd->groups->__cpu_power = 0;
> >  		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
> >  	}
> > -
> >  }
> >  
> >  /*
> 

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


