Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYBFGcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYBFGcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYBFGc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:32:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYBFGc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:32:27 -0500
Date: Tue, 5 Feb 2008 22:32:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-Id: <20080205223242.f444fad6.akpm@linux-foundation.org>
In-Reply-To: <200802060108.31644.dtor@insightbb.com>
References: <200802060108.31644.dtor@insightbb.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks OK.  Minorish things from a quick scan:



tosakbd_scankeyboard() looks like it'll spend a perfectly wicked amount of
time under spin_lock_irqsave().



This code, in tosakbd_probe():

+fail2:
+	while (--i >= 0)
+		gpio_free(TOSA_GPIO_KEY_STROBE(i));
+
+	i = TOSA_KEY_SENSE_NUM;
+fail:
+	while (--i >= 0) {
+		free_irq(gpio_to_irq(TOSA_GPIO_KEY_SENSE(i)), pdev);
+		gpio_free(TOSA_GPIO_KEY_SENSE(i));
+	}

looks like it'll free irqs and gpios which were never allocated (if i <
TOSA_KEY_SENSE_NUM on entry).



+static int __devinit tosakbd_probe(struct platform_device *pdev) {

please integrate checkpatch into your merging process.




i8042_platform_init():

+#if defined(__i386__) || defined(__x86_64__)

use #ifdef CONFIG_X86?


