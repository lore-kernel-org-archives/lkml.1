Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYC0XIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYC0XIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYC0XIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:08:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41214 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYC0XIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:08:30 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] radio-cadet: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Thu, 27 Mar 2008 17:12:33 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, Fred Gleason <fredg@wava.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271712.34818.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to
pnp_get_resource() function when CONFIG_PNP=n.  (This is a
new interface that's not in mainline yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/media/radio/radio-cadet.c
===================================================================
--- work7.orig/drivers/media/radio/radio-cadet.c	2008-03-27 16:10:52.000000000 -0600
+++ work7/drivers/media/radio/radio-cadet.c	2008-03-27 17:02:20.000000000 -0600
@@ -587,6 +587,8 @@
 	.vidioc_s_input     = vidioc_s_input,
 };
 
+#ifdef CONFIG_PNP
+
 static struct pnp_device_id cadet_pnp_devices[] = {
 	/* ADS Cadet AM/FM Radio Card */
 	{.id = "MSM0c24", .driver_data = 0},
@@ -621,6 +623,10 @@
 	.remove		= NULL,
 };
 
+#else
+static struct pnp_driver cadet_pnp_driver;
+#endif
+
 static int cadet_probe(void)
 {
 	static int iovals[8]={0x330,0x332,0x334,0x336,0x338,0x33a,0x33c,0x33e};
