Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbYEJWhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbYEJWhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 18:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYEJWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 18:37:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44167 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYEJWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 18:37:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 May 2008 00:36:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] firewire: fw-sbp2: spin disks down on suspend and
 shutdown
To: linux1394-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Tino Keitel <tino.keitel@gmx.de>
In-Reply-To: <tkrat.fbd2e673d8db52fc@s5r6.in-berlin.de>
Message-ID: <tkrat.68352f1ac714c0c1@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
 <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
 <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
 <tkrat.939c665f57d83cd4@s5r6.in-berlin.de>
 <tkrat.9874e625d2b0a007@s5r6.in-berlin.de>
 <tkrat.fbd2e673d8db52fc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This instructs sd_mod to send START STOP UNIT on suspend and resume,
and on driver unbinding or unloading (including when the system is shut
down).

We don't do this though if multiple initiators may log in to the target.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1544,6 +1544,9 @@ static int sbp2_scsi_slave_configure(str
 
 	sdev->use_10_for_rw = 1;
 
+	if (sbp2_param_exclusive_login)
+		sdev->manage_start_stop = 1;
+
 	if (sdev->type == TYPE_ROM)
 		sdev->use_10_for_ms = 1;
 

-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/

