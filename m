Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYA0LGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYA0LGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYA0LGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:06:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56990 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbYA0LGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:06:08 -0500
Date: Sun, 27 Jan 2008 03:05:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: preemptible RCU bug (was Re: [git pull] scheduler changes for v2.6.25)
Message-ID: <20080127110559.GB28315@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080125203740.GA31784@elte.hu> <479B87B9.8080005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479B87B9.8080005@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 08:19:21PM +0100, Stefan Richter wrote:
> Ingo Molnar wrote:
> >  - Paul E. McKenney's preemptible RCU code.
> 
> BUG:  New Kconfig option without help text.
> 
> $ make oldconfig
> RCU implementation type:
> > 1. Classic RCU (CLASSIC_RCU) (NEW)
>   2. Preemptible RCU (PREEMPT_RCU) (NEW)
> choice[1-2]: ?
> 
> Sorry, no help available for this option yet.

Good catch!!!

This patch supplies help text for the "RCU implementation type"
kernel configuration choice.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Kconfig.preempt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -urpNa -X dontdiff linux-2.6.24-rt1/kernel/Kconfig.preempt linux-2.6.24-rt1-RCUconfighelp/kernel/Kconfig.preempt
--- linux-2.6.24-rt1/kernel/Kconfig.preempt	2008-01-27 02:52:36.000000000 -0800
+++ linux-2.6.24-rt1-RCUconfighelp/kernel/Kconfig.preempt	2008-01-27 03:05:22.000000000 -0800
@@ -131,6 +131,14 @@ choice
 	prompt "RCU implementation type:"
 	default PREEMPT_RCU if PREEMPT_RT
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
