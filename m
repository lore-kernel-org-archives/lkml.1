Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862Ab0ACMQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0ACMQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 07:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790Ab0ACMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 07:16:22 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56570 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0ACMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 07:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=H+gHww46pgYBW/jUfLE8htB38FAiwWGucEikV4BggjShTWUXCJXTROUzEUJOE0d34K
         dRKBUDGA/CtyCa5pUqxpaKZ7GVKsWs7ZJpG/NKrMESk1LfSdrhoM3VZHpYs5hD49ycA0
         DcbbT00LkT8cmHDFdA/uuVhIvG4wg7CqWGEe4=
Date: Sun, 3 Jan 2010 14:14:51 +0200
From: Dan Carpenter <error27@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] off by one bug
Message-ID: <20100103121451.GA21064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if irq == PCF50633_NUM_IRQ that puts us past the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/mfd/pcf50633-core.c	2010-01-03 14:10:10.000000000 +0200
+++ devel/drivers/mfd/pcf50633-core.c	2010-01-03 14:10:31.000000000 +0200
@@ -217,7 +217,7 @@ static struct attribute_group pcf_attr_g
 int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
 			void (*handler) (int, void *), void *data)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ || !handler)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
 		return -EINVAL;
 
 	if (WARN_ON(pcf->irq_handler[irq].handler))
@@ -234,7 +234,7 @@ EXPORT_SYMBOL_GPL(pcf50633_register_irq)
 
 int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
 {
-	if (irq < 0 || irq > PCF50633_NUM_IRQ)
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
 		return -EINVAL;
 
 	mutex_lock(&pcf->lock);
