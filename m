Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZKRIaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZKRIaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZKRIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:30:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:53619 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZKRIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:30:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=q/u9SkTpXHQP1bp+izmpcELMq7vqn+C69bXDGIvjL4PoKLpMsPsmZP4Vhqa5OeJWQ7
         bO7A3dp6tIdmnimbikLcGOEYtd+4nkP/OOVhWZcUbjE8ufX2GYpZ2iWFt4hlZiAWcrF+
         K2ank/QfMnhPMttaNblAhmmU1u3RqoTuFbiII=
Date: Wed, 18 Nov 2009 10:30:14 +0200 (SAST)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: balajirrao@openmoko.org
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [patch] rtc: use after free in pcf50633_rtc_probe()
Message-ID: <alpine.DEB.2.00.0911161312140.12810@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"rtc" is freed and then dereferenced on the next line.  This patch fixes 
that.

This is a resend.  I have been offline for the last few months so I may 
have missed a reply or something.  Not sure what the status was.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/rtc/rtc-pcf50633.c	2009-07-17 16:21:52.000000000 +0300
+++ new/drivers/rtc/rtc-pcf50633.c	2009-07-17 16:22:56.000000000 +0300
@@ -291,8 +291,9 @@
 				&pcf50633_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc->rtc_dev)) {
+		int ret =  PTR_ERR(rtc->rtc_dev);
 		kfree(rtc);
-		return PTR_ERR(rtc->rtc_dev);
+		return ret;
 	}
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
