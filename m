Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZBESAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZBESAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBESAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:00:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBESAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:00:30 -0500
Date: Thu, 5 Feb 2009 19:00:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Ed Swierk <eswierk@aristanetworks.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
Message-ID: <20090205180019.GC9233@elte.hu>
References: <1233765552.16414.6.camel@localhost.localdomain> <20090204170440.GA31973@elte.hu> <200902051705.33410.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902051705.33410.tvrtko.ursulin@sophos.com>
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


* Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:

> On Wednesday 04 February 2009 17:04:40 Ingo Molnar wrote:
> > 2) Please use vertical spaces when initializing structure fields. Instead
> > of the messy looking (and over-long-line generating) construct of:
> >
> >         pci_mmcfg_config[0].address = (extcfg & 0x00007fff) << 25;
> >         pci_mmcfg_config[0].pci_segment = 0;
> >         pci_mmcfg_config[0].start_bus_number = 0;
> >         pci_mmcfg_config[0].end_bus_number = (1 << (8 - ((extcfg >> 28) &
> > 3))) - 1; pci_mmcfg_config_num = 1;
> >
> >    You will get something like:
> >
> >         config->address                 = (extcfg & 0x00007fff) << 25;
> >         config->pci_segment             = 0;
> >         config->start_bus_number        = 0;
> >         config->end_bus_number          = (1 << (8 - ((extcfg >> 28) &
> > 3)));
> >
> >         pci_mmcfg_config = config;
> >         pci_mmcfg_config_num = 1;
> >
> >    Which makes it more structured, more reviewable - and more pleasant to
> >    look at as well.

It is arch/x86/ and scheduler / etc. policy for new code - and we follow 
that principle when we clean up code as well.

Same goes for static structure initializers. We do:

 static const struct file_operations perf_fops = {
	.release		= perf_release,
	.read			= perf_read,
	.poll			= terf_poll,
	.unlocked_ioctl		= perf_ioctl,
	.compat_ioctl		= perf_ioctl,
 };

And not:

 static const struct file_operations perf_fops = {
	.release = perf_release,
	.read = perf_read,
	.poll = perf_poll,
	.unlocked_ioctl	= perf_ioctl,
	.compat_ioctl = pert_ioctl,
 };

Beyond the prettiness and fun to look at factor, there are other advantages 
of vertical spaces as well:

Trivia: you play the role of the code reviewer. I have hidden two typos in 
the initializers above, one in each initializer block. The typos are of the 
same type but are in difference places so both need to be found 
individually.

Try to find the typos, and record the number of seconds it took for you to 
find them. Which typo took less time to find?

I'd suspect that for most people block#1 is the winner.

[ Note, you have a look at it as real source code with fixed width fonts and 
  you'll see the difference. You seem to be using KMail or so: there's weird 
  line wraps and other corruption of the code in your quote above - have you 
  really looked at the real code how it looks like to developers? ]

> I find it a matter of personal preference whether it is more pleasant to 
> look at and whether it is more or less readable.

Is your argument that to you it is less pleasant to look at?

Differences in taste is OK in borderline issues, but i think this one is far 
from being borderline, it's a basic typographic and aesthetic principle.

I'm not sure vertical spaces can be properly described via more rigid 
CodingStyle rules - for example vertical spaces look ugly if there's just 
two field initializations for example - but in the above case they are 
clearly the right thing to do.

	Ingo
