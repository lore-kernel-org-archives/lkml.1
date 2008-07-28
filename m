Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbYG1MYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbYG1MYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYG1MYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:24:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYG1MYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:24:24 -0400
Date: Mon, 28 Jul 2008 14:24:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       akataria@vmware.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove stray <6> in BogoMIPS printk
Message-ID: <20080728122401.GB5515@elte.hu>
References: <20080727181700.GA2074@debian> <1217185324.6056.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217185324.6056.19.camel@localhost>
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


* Joe Perches <joe@perches.com> wrote:

> On Sun, 2008-07-27 at 23:47 +0530, Rabin Vincent wrote:
> > Remove the extra KERN_INFO which causes this:
> > Calibrating delay loop... <6>179.40 BogoMIPS (lpj=897024)
> > -	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
> > -			loops_per_jiffy/(500000/HZ),
> > -			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
> > +	printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
> > +		loops_per_jiffy/(500000/HZ),
> > +		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
> >  }
> 
> How about just using KERN_CONT and leaving the whitespace
> for a patch that does the entire file?
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index 7963e3f..51c5cec 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -170,7 +170,7 @@ void __cpuinit calibrate_delay(void)
>  				loops_per_jiffy &= ~loopbit;
>  		}
>  	}
> -	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
> +	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
>  			loops_per_jiffy/(500000/HZ),
>  			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);

ok - i've applied the patch below. Please send the full-file cleanup as 
a separate patch if anyone is interested in doing it.

	Ingo

------------>
>From d7ba11d01cfedf63b50391fbe4a05274b6992b43 Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Sun, 27 Jul 2008 12:02:04 -0700
Subject: [PATCH] x86: remove stray <6> in BogoMIPS printk

Rabin Vincent noticed that there's a stray <6> in BogoMIPS printk:

> Remove the extra KERN_INFO which causes this:
> Calibrating delay loop... <6>179.40 BogoMIPS (lpj=897024)
> -	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
> -			loops_per_jiffy/(500000/HZ),
> -			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
> +	printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
> +		loops_per_jiffy/(500000/HZ),
> +		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
>  }

How about just using KERN_CONT and leaving the whitespace
for a patch that does the entire file?

Reported-by: Rabin Vincent <rabin@rab.in>
---
 init/calibrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 7963e3f..a379c90 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -170,7 +170,7 @@ void __cpuinit calibrate_delay(void)
 				loops_per_jiffy &= ~loopbit;
 		}
 	}
-	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
+	printk(KERN_CONT "%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
 			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
