Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXDQJdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXDQJdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXDQJdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:33:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:58882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXDQJdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:33:09 -0400
Date: Tue, 17 Apr 2007 11:32:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417093257.GA9267@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <46247DAB.1060808@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46247DAB.1060808@shadowen.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 08:56:27AM +0100, Andy Whitcroft wrote:
> > 
> > as usual, any sort of feedback, bugreports, fixes and suggestions are
> > more than welcome,
> 
> Pushed this through the test.kernel.org and nothing new blew up.
> Notably the kernbench figures are within expectations even on the bigger
> numa systems, commonly badly affected by balancing problems in the
> schedular.
> 
> I see there is a second one out, I'll push that one through too.

Well I just sent some feedback on cfs-v2, but realised it went off-list,
so I'll resend here because others may find it interesting too. Sorry
about jamming it in here, but it is relevant to performance...

Anyway, roughly in the context of good cfs-v2 interactivity, I wrote:

Well I'm not too surprised. I am disappointed that it uses such small
timeslices (or whatever they are called) as the default.

Using small timeslices is actually a pretty easy way to ensure everything
stays smooth even under load, but is bad for efficiency. Sure you can say
you'll have desktop and server tunings, but... With nicksched I'm testing
a default timeslice of *300ms* even on the desktop, wheras Ingo's seems
to be effectively 3ms :P So if you compare default tunings, it isn't
exactly fair!

Kbuild times on a 2x Xeon:

2.6.21-rc7
508.87user 32.47system 2:17.82elapsed 392%CPU
509.05user 32.25system 2:17.84elapsed 392%CPU
508.75user 32.26system 2:17.83elapsed 392%CPU
508.63user 32.17system 2:17.88elapsed 392%CPU
509.01user 32.26system 2:17.90elapsed 392%CPU
509.08user 32.20system 2:17.95elapsed 392%CPU

2.6.21-rc7-cfs-v2
534.80user 30.92system 2:23.64elapsed 393%CPU
534.75user 31.01system 2:23.70elapsed 393%CPU
534.66user 31.07system 2:23.76elapsed 393%CPU
534.56user 30.91system 2:23.76elapsed 393%CPU
534.66user 31.07system 2:23.67elapsed 393%CPU
535.43user 30.62system 2:23.72elapsed 393%CPU

2.6.21-rc7-nicksched
505.60user 32.31system 2:17.91elapsed 390%CPU
506.55user 32.42system 2:17.66elapsed 391%CPU
506.41user 32.30system 2:17.85elapsed 390%CPU
506.48user 32.36system 2:17.77elapsed 391%CPU
506.10user 32.40system 2:17.81elapsed 390%CPU
506.69user 32.16system 2:17.78elapsed 391%CPU

