Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbZJPR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbZJPR25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbZJPR24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:28:56 -0400
Received: from kroah.org ([198.145.64.141]:48431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZJPRSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:13 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:48 2009
Message-Id: <20091016171148.314370239@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:09:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dennis OBrien <dennis.obrien@eqware.net>,
       Eric Miao <eric.y.miao@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [04/46] ARM: pxa: workaround errata #37 by not using half turbo switching
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=arm-pxa-workaround-errata-37-by-not-using-half-turbo-switching.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dennis O'Brien <dennis.obrien@eqware.net>

commit 4367216a099b4df3fa2c4f2b086cda1a1e9afc4e upstream.

PXA27x Errata #37 implies system will hang when switching into or out of
half turbo (HT bit in CLKCFG) mode, workaround this by not using it.

Signed-off-by: Dennis O'Brien <dennis.obrien@eqware.net>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/cpufreq-pxa2xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
@@ -155,7 +155,7 @@ MODULE_PARM_DESC(pxa255_turbo_table, "Se
 
 static pxa_freqs_t pxa27x_freqs[] = {
 	{104000, 104000, PXA27x_CCCR(1,	 8, 2), 0, CCLKCFG2(1, 0, 1),  900000, 1705000 },
-	{156000, 104000, PXA27x_CCCR(1,	 8, 6), 0, CCLKCFG2(1, 1, 1), 1000000, 1705000 },
+	{156000, 104000, PXA27x_CCCR(1,	 8, 3), 0, CCLKCFG2(1, 0, 1), 1000000, 1705000 },
 	{208000, 208000, PXA27x_CCCR(0, 16, 2), 1, CCLKCFG2(0, 0, 1), 1180000, 1705000 },
 	{312000, 208000, PXA27x_CCCR(1, 16, 3), 1, CCLKCFG2(1, 0, 1), 1250000, 1705000 },
 	{416000, 208000, PXA27x_CCCR(1, 16, 4), 1, CCLKCFG2(1, 0, 1), 1350000, 1705000 },


