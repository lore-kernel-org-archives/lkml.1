Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZDOH5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZDOH5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZDOH5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:57:16 -0400
Received: from relay.atmel.no ([80.232.32.139]:63924 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZDOH5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:57:16 -0400
Date: Wed, 15 Apr 2009 09:57:10 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: tglx@linutronix.de, David Brownell <david-b@pacbell.net>,
       hskinnemoen@atmel.com, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, imre.deak@nokia.com, mingo@elte.hu
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
 irq handling on AVR32
Message-ID: <20090415095710.5c853a7f@hskinnemoen-d830>
In-Reply-To: <1239759053.29831.37.camel@linux-51e8.site>
References: <1239685153.19815.12.camel@linux-51e8.site>
	<1239698225.29831.14.camel@linux-51e8.site>
	<1239759053.29831.37.camel@linux-51e8.site>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> static irqreturn_t ads7846_irq(int irq, void *handle)
> {
> 	struct ads7846 *ts = handle;
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&ts->lock, flags);
> 	if (likely(get_pendown_state(ts))) {
> 		if (!ts->irq_disabled) {
> 			/* The ARM do_simple_IRQ() dispatcher doesn't act
> 			 * like the other dispatchers:  it will report IRQs
> 			 * even after they've been disabled.  We work around
> 			 * that here.  (The "generic irq" framework may help...)
> 			 */
> 			ts->irq_disabled = 1;
> 			disable_irq(ts->spi->irq);

Shouldn't that be disable_irq_nosync()?

Haavard
