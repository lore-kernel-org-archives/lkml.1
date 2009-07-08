Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZGHWno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZGHWno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZGHWnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:43:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50807 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZGHWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qbGBW9W7a1KoxUtnPhIJlybLpYH1L3BhiyfLYlzA5TE3rZIG6CHOWxul0dt8b85EP2
         mZuHcNwAwDAgny2/LVcOAAyXtXgaFyzAgFP9ppZdrOsLVabNZZ54lykZoE4q6OCziIpz
         ixhw4eROjQkwskfBCiAfoisHCy+HmtbJt6yQQ=
Date: Thu, 9 Jul 2009 00:42:59 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Andres Freund <andres@anarazel.de>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090708224259.GC3666@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> <20090708080852.GC3148@ami.dom.local> <200907081029.34527.andres@anarazel.de> <20090708091344.GD3148@ami.dom.local> <a5d9929e0907081444r4a1e0828taf538c686577f09c@mail.gmail.com> <20090708220749.GA3666@ami.dom.local> <a5d9929e0907081527n38a4c369k5b886520b7cc0229@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5d9929e0907081527n38a4c369k5b886520b7cc0229@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:27:30PM +0100, Joao Correia wrote:
> On Wed, Jul 8, 2009 at 11:07 PM, Jarek Poplawski<jarkao2@gmail.com> wrote:
> > On Wed, Jul 08, 2009 at 10:44:47PM +0100, Joao Correia wrote:
> >> Hello again
> > Hello!
> >
> > ...
> >> So again, the only thing that stops that freeze is  `echo 0 >>
> >> /proc/sys/kernel/timer_migration`. Apologies for pointing you in the
> >> wrong direction.
> >
> > No problem: the direction is almost right, we only need one U-turn ;-)
> > In case you're not bored or too bored, one little patch to check the
> > other side (after reverting the previous patch).
> >
> > Thanks,
> > Jarek P.
> > ---
> >
> >  kernel/hrtimer.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 9002958..23387e4 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -203,7 +203,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
> >        int cpu, preferred_cpu = -1;
> >
> >        cpu = smp_processor_id();
> > -#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
> > +#if 0
> >        if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
> >                preferred_cpu = get_nohz_load_balancer();
> >                if (preferred_cpu >= 0)
> >
> 
> (this time i triple-checked :-) )
> 
> So, with only this last patch applied, no freeze. No need to disable
> anything through /proc.
> 
> Where should i put the BUG_ON?

Hmm... Not so fast! I've looked in timers till now; "tomorrow" I'll
"change resolution". ;-)

Thanks again,
Jarek P.
