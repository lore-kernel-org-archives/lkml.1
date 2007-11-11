Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXKKTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXKKTDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXKKTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:03:42 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4024 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbXKKTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:03:41 -0500
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 14:03:40 EST
Message-ID: <47374EA4.1060009@xs4all.nl>
Date: Sun, 11 Nov 2007 19:49:08 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: enable dual rng on VIA C7
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: multipart/mixed;
 boundary="------------030008010503010803080505"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030008010503010803080505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Any reason why the second rng on the VIA C7 CPU is not enabled?

Kind regards,
Udo

--------------030008010503010803080505
Content-Type: text/plain;
 name="via-rng.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="via-rng.patch"

--- old/drivers/char/hw_random/via-rng.c	2007-11-11 19:39:49.000000000 +0100
+++ new/drivers/char/hw_random/via-rng.c	2007-11-11 19:40:41.000000000 +0100
@@ -41,6 +41,7 @@
 	VIA_STRFILT_ENABLE	= (1 << 14),
 	VIA_RAWBITS_ENABLE	= (1 << 13),
 	VIA_RNG_ENABLE		= (1 << 6),
+	VIA_RNG_DUAL            = (1 << 9),
 	VIA_XSTORE_CNT_MASK	= 0x0F,
 
 	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
@@ -128,6 +129,7 @@
 	lo &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
 	lo &= ~VIA_XSTORE_CNT_MASK;
 	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
+	lo |= VIA_RNG_DUAL;
 	lo |= VIA_RNG_ENABLE;
 
 	if (lo != old_lo)

--------------030008010503010803080505--
