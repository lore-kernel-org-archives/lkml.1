Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYCXTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYCXTxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYCXTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:53:18 -0400
Received: from vena.lwn.net ([206.168.112.25]:38641 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYCXTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:53:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stern@rowland.harvard.edu, khali@linux-fr.org, mb@bu3sch.de,
       hmh@hmh.eng.br, david-b@pacbell.net, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mingo@elte.hu, geert@linux-m68k.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 24 Mar 2008 12:42:29 PDT."
             <20080324124229.5d49ded6.akpm@linux-foundation.org> 
Date: Mon, 24 Mar 2008 13:53:17 -0600
Message-ID: <25897.1206388397@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> It'd be better if the comment were to describe _why_ in_atomic() is
> unreliable.  ie: "does not account for held spinlocks on non-preemptible
> kernels".

But then...why would anybody have a reason to read the upcoming LWN
article on the subject?  

OK, how's this?

jon

--

Discourage people from inappropriately using in_atomic()

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 4982998..63a7782 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -72,6 +72,13 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
+/*
+ * Are we running in atomic context?  WARNING: this macro cannot
+ * always detect atomic context; in particular, it cannot know about
+ * held spinlocks in non-preemptible kernels.  Thus it should not be
+ * used in the general case to determine whether sleeping is possible.
+ * Do not use in_atomic() in driver code.
+ */
 #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
 
 #ifdef CONFIG_PREEMPT
