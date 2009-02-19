Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZBSLCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZBSLCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZBSLCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:02:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZBSLCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:02:06 -0500
Date: Thu, 19 Feb 2009 12:01:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Message-ID: <20090219110142.GH2354@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org> <20090219021015.aac6ea43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219021015.aac6ea43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > + * To use this allocator, arch code should do the followings.
> > + *
> > + * - define CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
> > + *
> > + * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
> > + *   regular address to percpu pointer and back
> > + *
> > + * - use pcpu_setup_static() during percpu area initialization to
> > + *   setup kernel static percpu area
> > + */
> 
> afacit nobody has answered your "is num_possible_cpus() ever a 
> lot larger than num_online_cpus()" question.
> 
> It is fairly important.

yeah.

On x86 we limit num_possible_cpus() at boot time from NR_CPUS to 
the BIOS-enumerated set of possible CPUs - i.e. the two will 
always be either equal, or be very close to each other.

( there used to be broken early BIOSes that enumerated more CPUs 
  than needed but it's very rare and because it also wastes BIOS 
  RAM/ROM it's something they'll usually avoid even if they dont 
  care about Linux. )

So this should be a pretty OK assumption.

	Ingo
