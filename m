Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbXCOVMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbXCOVMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXCOVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:12:13 -0400
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:59236 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbXCOVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:12:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ray-gmail@madrabbit.org
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Date: Fri, 16 Mar 2007 08:11:50 +1100
User-Agent: KMail/1.9.5
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
References: <200703121058.11966.kernel@kolivas.org> <20070315174654.GB12447@linux-os.sc.intel.com> <2c0942db0703151158l59cbede2x845fc134d9f1cf9d@mail.gmail.com>
In-Reply-To: <2c0942db0703151158l59cbede2x845fc134d9f1cf9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703160811.51088.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 05:58, Ray Lee wrote:
> On 3/15/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > On Thu, Mar 15, 2007 at 05:05:13PM +1100, Con Kolivas wrote:
> > > On Thursday 15 March 2007 13:31, Siddha, Suresh B wrote:
> > > > Just to see the % increase in number of context switches, I ran 8
> > > > infinite loops (simple while(1); 's) and with 2.6.21-rc3 I see ~70
> > > > context switches every second, whereas with RSDL I see ~530 context
> > > > switches.
> > >
> > > Thanks. If it's just that then scaling rr interval with cpus somewhat
> > > would help. If you could, the following patch just to test might
> > > confirm that. -#define RR_INTERVAL          ((6 * HZ / 1001) + 1)
> > > +#define RR_INTERVAL          ((12 * HZ / 1001) + 1)
> >
> > Context switches now are ~370 per second. Still much above the regular
> > ~70 we see in the mainline.
> >
> > why do you say the rr_interval needs to be scaled with cpus? The basic
> > point in RSDL is, if we have more than one same priority task on a single
> > logic cpu, context switch happens every RR_INTERVAL (6 or 12 msec)
> > whereas in mainline it happens every 100 msec.

No. That's what we do with mainline too. The analogue of the RR_INTERVAL in 
mainline is the timeslice granularity. When I wrote it (TG) I assumed that 
any increase in latency by lengthening this value would be offset by more 
cpus being available which is only partially true. I also did not assume at 
the time that many cpus would be used on a desktop which is now, wrong. 

> With more CPUs, the context switch period can be multiplied by that
> number of CPUs while still allowing all tasks the same frequency of
> access to the CPU. With 4 processors, the context switch would be
> 24ms, by which point we're probably reaching the point of diminishing
> returns for minimizing overhead and maximizing throughput.
>
> > We need to minimize these context switches.
>
> That's a judgement call. If a synthetic benchmark degrades but other
> things improve, then this, as most everything in computer science, is
> yet another trade-off that needs to be evaluated. (You recognize there
> is a tradeoff here, right? Some benchmarks would improve even further
> if the switch time were 500ms. But that would make the system nearly
> unusable in general.)
>
> Ray

-- 
-ck
