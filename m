Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842Ab0ACMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0ACMJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 07:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649Ab0ACMJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 07:09:15 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37547 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0ACMJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 07:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kh1osKg1/83LHJmO4DVmlv+rGzp7bceAzs+Z9zVVl+WGQPUBzhH8IygPIbaeNL6+uw
         XiBGPARse92Lu/YZmtdg9EV+JNFXon/ytmBYVSCl2/hQDzkOfH7XUQzbeGPV7OLHqggp
         JcxkaE8vVSvUfBEYad8FPFHn/AJl/gvb7CiOg=
Date: Sun, 3 Jan 2010 14:08:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [patch] off by one bug
Message-ID: <20100103120817.GA19360@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If irq == WM8350_NUM_IRQ that would put us past the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/mfd/wm8350-irq.c	2010-01-03 14:02:43.000000000 +0200
+++ devel/drivers/mfd/wm8350-irq.c	2010-01-03 14:04:18.000000000 +0200
@@ -434,7 +434,7 @@ int wm8350_register_irq(struct wm8350 *w
 			irq_handler_t handler, unsigned long flags,
 			const char *name, void *data)
 {
-	if (irq < 0 || irq > WM8350_NUM_IRQ || !handler)
+	if (irq < 0 || irq >= WM8350_NUM_IRQ || !handler)
 		return -EINVAL;
 
 	if (wm8350->irq[irq].handler)
@@ -453,7 +453,7 @@ EXPORT_SYMBOL_GPL(wm8350_register_irq);
 
 int wm8350_free_irq(struct wm8350 *wm8350, int irq)
 {
-	if (irq < 0 || irq > WM8350_NUM_IRQ)
+	if (irq < 0 || irq >= WM8350_NUM_IRQ)
 		return -EINVAL;
 
 	wm8350_mask_irq(wm8350, irq);
