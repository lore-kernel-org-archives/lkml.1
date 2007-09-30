Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbXI3PoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbXI3PoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXI3Pn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:43:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbXI3Pn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:43:58 -0400
Date: Sun, 30 Sep 2007 17:43:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
	v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070930154354.GD24077@elte.hu>
References: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew <jackdachef@gmail.com> wrote:

> both cpus have a continous load of ~ 70% right now so I'll be starting 
> up 9 instances of glxgears, below are some output & details of my 
> system (cpu frequency switching is disabled since it doesn't work 
> right now with the current bios version)
> 
> short summary: unfortunately after starting glxgears everything 
> stuttered a lot, don't know if it's expactable during that heavy load 
> - just wanted to let you know; after having closed each instance of 
> glxgears, everything was fine again ...

> cpu#0, 2404.249 MHz
> cpu#1, 2404.249 MHz

> result: most times only 2-3 of the glxgears-windows were running, the 
> rest was stuttering / halting (no motion) mouse movement was pretty 
> discountinous, keyboard input was also delayed

how does it behave without the cfs patch applied? Does it work better 
under v20.5? The best debug output for me to look at would be to 
download these two scripts:

 http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
 http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info-clear.sh

first run cfs-debug-info-clear.sh, then use the system for a few minutes 
and make sure apps are behaving in a 'stutter-free' way. Then run 
cfs-debug-info.sh (still no glxgears running) - it will produce a "no 
load" debug info file. Then start the 9x glxgears instances, reproduce 
the "stuttering" behavior in the apps, and run cfs-debug-info.sh - this 
will produce a second "under load" output file. Please send me both 
output files.

also, what's the output of "glxgears -info" - does it render on real 3D 
hardware, or uses the sw-mesa fallback?

	Ingo
