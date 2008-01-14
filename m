Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbYANO71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbYANO71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYANO7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:59:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYANO7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:59:16 -0500
Date: Mon, 14 Jan 2008 15:58:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114145854.GA31695@elte.hu>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114140910.GA8507@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > ok, i've dropped this patch from x86.git for now:
> > 
> >  Subject: x86: force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
> >  From: Andi Kleen <ak@suse.de>
> > 
> > but longer-term, shouldnt these annotations be automated? We'll see 
> > a constant stream of them, all around the clock as people regularly 
> > get it wrong (because it's not intuitive).
>
> Would be great to have them automated - just dunno how to do it. Do 
> you see a feasible way to do it?

a good starting point would be to make the warnings a lot more 
self-explanatory. Right now it's often non-obvious trying to figure out 
how the dependencies are structured and which one should be changed to 
get rid of the bug.

> Short term modpost etc. will be enhanced to be less dependent on the 
> actual configuration when performing the checks. It should not matter 
> if CONFIG_HOTPLUG_CPU is enabled or not when we check the __cpuint 
> annotations but this is how we see it today so far too many faults 
> slip through.

a good way i see is to:

 - improve the debug output so that it's obvious at a glance what the 
   problem is.

 - quickly reach a close-to-100%-perfect stage, brute-force. Drop 
   __init* annotations en masse if they are not perfectly layered. 
   Whoever reintroduces them will then have to do it perfectly.

 - then turn these into hard failures (which they _are_ in a significant 
   percentage of the situations).

once it's a hard build failure, people will fix them quickly and 
automated tests will pick them up as well.

	Ingo
