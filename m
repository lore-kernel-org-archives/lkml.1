Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYE3PD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYE3PD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYE3PDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:03:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbYE3PDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:03:20 -0400
Date: Fri, 30 May 2008 17:02:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.iguana.be,
       Thomas <Thomas.Mingarelli@hp.com>,
       Jordan Crouse <jordan.crouse@amd.com>, Chen Gong <g.chen@freescale.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: [patch] drivers/watchdog/geodewdt.c: build fix
Message-ID: <20080530150250.GA21945@elte.hu>
References: <20080525100944.GA4084@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525100944.GA4084@infomag.infomag.iguana.be>
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


* Wim Van Sebroeck <wim@iguana.be> wrote:

> Author: Jordan Crouse <jordan.crouse@amd.com>
> Date:   Mon Jan 21 10:07:00 2008 -0700
> 
>     [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers

-tip testing found the following build failure on latest -git:

  drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
  drivers/watchdog/geodewdt.c:225: error: too many arguments to function 'geode_mfgpt_alloc_timer'
  make[1]: *** [drivers/watchdog/geodewdt.o] Error 1
  make: *** [drivers/watchdog/geodewdt.o] Error 2

with this config:

  http://redhat.com/~mingo/misc/config-Fri_May_30_15_19_52_CEST_2008.bad

find the fix below.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/watchdog/geodewdt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: tip/drivers/watchdog/geodewdt.c
===================================================================
--- tip.orig/drivers/watchdog/geodewdt.c
+++ tip/drivers/watchdog/geodewdt.c
@@ -221,8 +221,7 @@ geodewdt_probe(struct platform_device *d
 {
 	int ret, timer;
 
-	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
-					MFGPT_DOMAIN_WORKING, THIS_MODULE);
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 
 	if (timer == -1) {
 		printk(KERN_ERR "geodewdt:  No timers were available\n");
