Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYA0HNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYA0HNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 02:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYA0HMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 02:12:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYA0HMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 02:12:53 -0500
Date: Sun, 27 Jan 2008 08:12:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kevin Winchester <kjwinchester@gmail.com>
Subject: [git pull] printk fix (was: Re: X fails to start with latest Linus
	git)
Message-ID: <20080127071240.GA31946@elte.hu>
References: <479BCE03.6070603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479BCE03.6070603@gmail.com>
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


Linus,

please pull the following printk fix:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it reverts 19ef9309273d: Kevin Winchester reported a 
CONFIG_PRINTK_TIME=y related hang during X startup, and biscted it down 
to this commit.

	Ingo

------------------>
Ingo Molnar (1):
      printk: revert ktime_get() timestamps

 printk.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 423a8c7..3b7c968 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -702,9 +702,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 					loglev_char = default_message_loglevel
 						+ '0';
 				}
-				t = 0;
-				if (system_state != SYSTEM_BOOTING)
-					t = ktime_to_ns(ktime_get());
+				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
 				tlen = sprintf(tbuf,
 						"<%c>[%5lu.%06lu] ",

