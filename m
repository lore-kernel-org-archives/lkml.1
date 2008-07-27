Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbYG0TCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbYG0TCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYG0TCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:02:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1501 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYG0TCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:02:10 -0400
Subject: Re: [PATCH] Remove stray <6> in BogoMIPS printk
From: Joe Perches <joe@perches.com>
To: Rabin Vincent <rabin@rab.in>
Cc: lkml <linux-kernel@vger.kernel.org>, akataria@vmware.com,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080727181700.GA2074@debian>
References: <20080727181700.GA2074@debian>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 12:02:04 -0700
Message-Id: <1217185324.6056.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-27 at 23:47 +0530, Rabin Vincent wrote:
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

diff --git a/init/calibrate.c b/init/calibrate.c
index 7963e3f..51c5cec 100644
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


