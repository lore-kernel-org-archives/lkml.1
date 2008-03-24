Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYCXTe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYCXTe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYCXTeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:34:50 -0400
Received: from vena.lwn.net ([206.168.112.25]:35627 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbYCXTeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:34:50 -0400
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jean Delvare <khali@linux-fr.org>, Michael Buesch <mb@bu3sch.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       akpm@linux-foundation.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 21 Mar 2008 14:05:59 EDT."
             <Pine.LNX.4.44L0.0803211343240.24421-100000@netrider.rowland.org> 
Date: Mon, 24 Mar 2008 13:34:49 -0600
Message-ID: <23456.1206387289@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:

> There's also a section about in_atomic() in the Linux Device Drivers 
> (3rd ed.) book which may have contributed to the confusion.

My fault (again).  Obviously it *looked* like something people could use
to me...  

How about the following patch as a short-term penance to keep others
from making the same mistake?

jon

--

Discourage people from using in_atomic()

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 4982998..3d196cb 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -72,6 +72,11 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
+/*
+ * Are we running in atomic context?  WARNING: this macro cannot
+ * always detect atomic context and should not be used to determine
+ * whether sleeping is possible.  Do not use it in driver code.
+ */
 #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
 
 #ifdef CONFIG_PREEMPT

