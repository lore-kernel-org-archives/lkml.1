Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYA0M0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYA0M0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYA0M02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:26:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYA0M02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:26:28 -0500
Date: Sun, 27 Jan 2008 13:26:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: preemptible RCU bug (was Re: [git pull] scheduler changes for
	v2.6.25)
Message-ID: <20080127122602.GA17293@elte.hu>
References: <20080125203740.GA31784@elte.hu> <479B87B9.8080005@s5r6.in-berlin.de> <20080127110559.GB28315@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127110559.GB28315@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > Sorry, no help available for this option yet.
> 
> Good catch!!!
> 
> This patch supplies help text for the "RCU implementation type" kernel 
> configuration choice.

thanks applied to sched.git. (see the patch below - the config option is 
in init/Kconfig in mainline, not in kernel/Kconfig.preempt)

	Ingo

------------->
Subject: RCU: add help text for "RCU implementation type"
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This patch supplies help text for the "RCU implementation type"
kernel configuration choice.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 init/Kconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -779,6 +779,14 @@ config PREEMPT_NOTIFIERS
 choice
 	prompt "RCU implementation type:"
 	default CLASSIC_RCU
+	help
+	  This allows you to choose either the classic RCU implementation
+	  that is designed for best read-side performance on non-realtime
+	  systems, or the preemptible RCU implementation for best latency
+	  on realtime systems.  Note that some kernel preemption modes
+	  will restrict your choice.
+
+	  Select the default if you are unsure.
 
 config CLASSIC_RCU
 	bool "Classic RCU"
