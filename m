Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYECR6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYECR6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYECR6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:58:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765632AbYECR6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:58:21 -0400
Date: Sat, 3 May 2008 19:58:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch] video: build fix for drivers/media/video/mt9v022.c
Message-ID: <20080503175807.GC5292@elte.hu>
References: <20080503163058.GA15272@elte.hu> <Pine.LNX.4.64.0805031853180.5182@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805031853180.5182@axis700.grange>
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


* Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> > with this config:
> > 
> >    http://redhat.com/~mingo/misc/config-Sat_May__3_16_08_39_CEST_2008.bad
> > 
> > the bug was that the driver uses GPIO functionality but only 
> > includes the GPIO interface definitions for the 
> > CONFIG_MT9M001_PCA9536_SWITCH case, which was not set in this 
> > config.
> 
> Ok, once again a good catch and a wrong fix, sorry :-) The bug is that 
> not CONFIG_MT9M001_PCA9536_SWITCH but CONFIG_MT9V022_PCA9536_SWITCH 
> shall be checked for, of course. Copy-paste:-( I'll prepare a correct 
> patch and submit it. As for the "cleanup" side - don't know. Would it 
> be better to unconditionally include it? It won't hurt of course, 
> looks better, but is unneeded when the GPIO is not used. And, although 
> grep reports most drivers including asm/gpio.h, including linux/gpio.h 
> seems indeed better.

No. If you look at the core kernel you wont see it sprinkled with things 
like:

 #ifdef CONFIG_LOCKDEP
 #include <linux/lockdep.h>
 #endif

why? Because we have put all such things into the include file 
themselves and do not want to sprinkle .c files with ugly #ifdefs. This 
is a basic cleanliness issue.

Furthermore, if anyone _else_ copy & pastes your driver, this bug wont 
hit him anymore.

so please keep that #include <linux/gpio.h>.

	Ingo
