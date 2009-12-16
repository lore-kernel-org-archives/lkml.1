Return-Path: <linux-kernel-owner+w=401wt.eu-S934986AbZLPQUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986AbZLPQUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934910AbZLPQUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:20:15 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44215 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934958AbZLPQUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YSuSv/zfDCbvcXhrJq2PGoKMNSAL4EB6Ilg94Grs/oTob+THu2IKFRyxwiXkB6LdNN
         D3V2zExZQ//wf/LU2+vXSijCacIG/M9aDP2AsC4xlBEb8bs8Oz4prS2SME56xmTsS07Y
         fJ0a+GdT6+4kEuxnKqygi9XQXqttTzAJvkTzc=
Message-ID: <4B29092C.4040600@gmail.com>
Date: Wed, 16 Dec 2009 17:22:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: omap3_pm_get_suspend_state() error ignored in pwrdm_suspend_get()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val is an u64 pointer, we need an int to check the error.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index 860b755..081ca85 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -488,9 +488,11 @@ int pm_dbg_regset_init(int reg_set)
 
 static int pwrdm_suspend_get(void *data, u64 *val)
 {
-	*val = omap3_pm_get_suspend_state((struct powerdomain *)data);
+	int ret;
+	ret = omap3_pm_get_suspend_state((struct powerdomain *)data);
+	*val = ret;
 
-	if (*val >= 0)
+	if (ret >= 0)
 		return 0;
 	return *val;
 }
