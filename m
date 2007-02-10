Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXBJLnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXBJLnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXBJLnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:43:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:57751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXBJLnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:43:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: -mm merge plans for 2.6.21
Date: Sat, 10 Feb 2007 12:42:41 +0100
User-Agent: KMail/1.9.5
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <20070209105737.GF5785@slug> <1171020273.8675.150.camel@laptopd505.fenrus.org>
In-Reply-To: <1171020273.8675.150.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101242.42472.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18MqzG6HHmCuFqn/jUoAr/dysJkjzufjOFQHSJPXMuGvSX/skRc+LSVyaxl7+69Yl1gO2GwKJcb6RfIAQoqCsQ4FX0UrcGOpwUQbMmY8QDpLw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 12:24, Arjan van de Ven wrote:
> 
> On Fri, 2007-02-09 at 10:57 +0000, Frederik Deweerdt wrote:
> > +static const int __deprecated SA_INTERRUPT = IRQF_DISABLED;
> > +static const int __deprecated SA_SAMPLE_RANDOM = IRQF_SAMPLE_RANDOM;
> > +static const int __deprecated SA_SHIRQ = IRQF_SHARED;
> > +static const int __deprecated SA_PROBEIRQ = IRQF_PROBE_SHARED;
> > +static const int __deprecated SA_PERCPU = IRQF_PERCPU;
> > +
> > +static const int __deprecated SA_TRIGGER_LOW = IRQF_TRIGGER_LOW;
> > +static const int __deprecated SA_TRIGGER_HIGH = IRQF_TRIGGER_HIGH;
> > +static const int __deprecated SA_TRIGGER_FALLING = IRQF_TRIGGER_FALLING;
> > +static const int __deprecated SA_TRIGGER_RISING = IRQF_TRIGGER_RISING;
> > +static const int __deprecated SA_TRIGGER_MASK = IRQF_TRIGGER_MASK;
> 
> this will include these in every .o file for which the .c file includes
> the header. NOT GOOD(tm)
> 

How about this one instead then:

Mark SA_* constants as deprecated

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -53,17 +53,19 @@
  * Migration helpers. Scheduled for removal in 1/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+typedef unsigned int __deprecated deprecated_irqf;
+
+#define SA_INTERRUPT		((deprecated_irqf)IRQF_DISABLED)
+#define SA_SAMPLE_RANDOM	((deprecated_irqf)IRQF_SAMPLE_RANDOM)
+#define SA_SHIRQ		((deprecated_irqf)IRQF_SHARED)
+#define SA_PROBEIRQ		((deprecated_irqf)IRQF_PROBE_SHARED)
+#define SA_PERCPU		((deprecated_irqf)IRQF_PERCPU)
+
+#define SA_TRIGGER_LOW		((deprecated_irqf)IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_HIGH		((deprecated_irqf)IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_FALLING	((deprecated_irqf)IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_RISING	((deprecated_irqf)IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_MASK		((deprecated_irqf)IRQF_TRIGGER_MASK)
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
