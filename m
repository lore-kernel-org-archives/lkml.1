Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbXLTJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbXLTJcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXLTJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:32:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXLTJcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:32:01 -0500
Date: Thu, 20 Dec 2007 10:31:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071220093138.GE4478@elte.hu>
References: <20071219183443.GA547@linux-os.sc.intel.com> <20071219193255.GA2158@elte.hu> <20071220020846.GA13464@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220020846.GA13464@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> > Btw., since the TLB flush state machine is really subtle and 
> > fragile, could you try to run the following mmap stresstest i wrote 
> > some time ago:
> > 
> >    http://redhat.com/~mingo/threaded-mmap-stresstest/
> > 
> > for a couple of hours. It runs nr_cpus threads which then do a 
> > "random crazy mix" of mappings/unmappings/remappings of a 800 MB 
> > memory window. The more sockets/cores, the crazier the TLB races get 
> > ;-)
> > 
> 
> Ingo,
> 
> I ran this stress test on two systems (8 cores and 2 cores) for over 4 
> hours without any issues. There was more than 20% C3 time during the 
> run. So, this C3 tlbflush path must have been stressed well during the 
> run.

ok, great. Regarding power consumption: i suspect a real difference will 
only show up on multi-socket systems that can do deeper C modes, or on 
multicore systems that will benefit from longer idle time on another 
core. (i suspect most multicore CPUs today will only truly save 
significant amounts of power if all cores are idle.) In any case, not 
doing these extra IPIs is definitely a plus.

	Ingo
