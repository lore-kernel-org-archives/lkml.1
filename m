Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZA1XOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZA1XOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZA1XNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:13:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33158 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZA1XNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:13:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jan 2009 00:13:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH revised] ieee1394: sbp2: add workarounds for 2nd and 3rd
 generation iPods
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de>
Message-ID: <tkrat.9a5f1819d300396d@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
 <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
 <200901281718.41873.jarod@redhat.com> <200901281725.25750.jarod@redhat.com>
 <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as per https://bugs.launchpad.net/bugs/294391.  These got one sample of
each iPod generation going.  However there still occurred I/O stalls
with the 3rd generation iPod which remain undiagnosed at the time of
this writing.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -395,6 +395,16 @@ static const struct {
 		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/*
+	 * iPod 2nd generation: needs 128k max transfer size workaround
+	 * iPod 3rd generation: needs fix capacity workaround
+	 */
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,

-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/

