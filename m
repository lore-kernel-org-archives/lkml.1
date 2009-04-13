Return-Path: <linux-kernel-owner+w=401wt.eu-S1751155AbZDMQde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbZDMQde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZDMQdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:33:06 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:28276 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZDMQdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:33:04 -0400
X-Greylist: delayed 3203 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 12:33:03 EDT
Date: Mon, 13 Apr 2009 17:39:24 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, heukelum@fastmail.fm
Subject: [PATCH] Fix warnings after: x86: apic - introduce imcr_ helpers
Message-ID: <20090413153924.GA20287@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 13 Apr 2009 17:39:24 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.138; VDF: 7.1.3.43; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix compiler warnings

The patch "introduce imcr_ helpers" introduced good comments, but
also a few compile warnings. This fixes it.
    
Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

---

Hi Ingo,

Cyrill forgot to refresh the patches :).

Greetings,
    Alexander

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 054f604..c3c57b2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -107,7 +107,7 @@ static int enabled_via_apicbase;
  * the BIOS or the operating system must switch out of
  * PIC Mode by changing the IMCR.
  */
-static inline imcr_pic_to_apic(void)
+static inline void imcr_pic_to_apic(void)
 {
 	/* select IMCR register */
 	outb(0x70, 0x22);
@@ -115,7 +115,7 @@ static inline imcr_pic_to_apic(void)
 	outb(0x01, 0x23);
 }
 
-static inline imcr_apic_to_pic(void)
+static inline void imcr_apic_to_pic(void)
 {
 	/* select IMCR register */
 	outb(0x70, 0x22);
