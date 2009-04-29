Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZD2MPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZD2MPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZD2MPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:15:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:47407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZD2MPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:15:16 -0400
Subject: Re: [git-pull -tip] x86: cpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090429105021.GG2373@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam>
	 <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
	 <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam>
	 <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam>
	 <20090429105021.GG2373@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 17:44:54 +0530
Message-Id: <1241007294.3061.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 12:50 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Tue, 2009-04-28 at 19:28 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > @@ -850,10 +903,10 @@ static int cpu_init_cpu(void)
> > > >  		cpui = &cpu_data(cpu);
> > > >  		if (!cpu_has(cpui, X86_FEATURE_MSR))
> > > >  			continue;
> > > > -		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
> > > > -					   (cpui->x86 << 8) |
> > > > -					   (cpui->x86_model));
> > > > -		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
> > > > +		per_cpu(cpu_modelflag, cpu) = get_cpu_flag(cpui);
> > > > +		if (!per_cpu(cpu_modelflag, cpu))
> > > > +			send_report(per_cpu(cpu_priv_count, cpu), cpui);
> > > 
> > > This means that if the CPU is not enumerated in the model table 
> > > explicitly, we'll fall back to some really minimal output, right?
> > > 
> > 
> > Yes.
> 
> That's a bug really: it means that for every new CPU type that comes 
> around we need to update this code. I.e. precisely for those CPUs 
> where we might need the most help from such a debug facility, we 
> wont have much info to look at ... New CPUs generally support all 
> the CPU features that are displayed here, in a compatible manner.
> 
> So that needs to be improved/changed to not be tied to such a static 
> 'cpu model' enumeration but instead be CPU feature flags driven. See 
> all the existing cpu_has_*() tests we have.
> 

cpu_has_*() is based on boot_cpu. So you mean cpu_has tests. right ?

We can use cpu_has tests for unknown processors but 'cpu model' is
accurate and cover all range.

cpu_has does not cover following registers:
1. platform
2. poweron
3. control
4. bios
5. freq
6. cache
7. misc
8. base
9. ver
10. conf

So is this looks OK to you:

1. first check for 'cpu model' if CPU not supported then goto 2
2. check for cpu_has tests 

--
JSR




