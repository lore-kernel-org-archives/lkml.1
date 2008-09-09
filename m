Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYIIVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYIIVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYIIVCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:02:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:13162 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYIIVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nuWdgRVv2pEOhd6Ya0CcBGInLnmhr+hpSPQCjQg1GEyeKFIPER2DxlhTbEt9xM1RqC
         Bu4iur07FUCygJgXTsp/v93kn5WbaXtBTtInnMA2xsCY1fVcB6194NjAdnV9+Wl1+3HE
         fd6/ivW/WnhwNeVWLgkvpzuLZrCty69YAk0us=
Message-ID: <48C6E473.9070408@gmail.com>
Date: Tue, 09 Sep 2008 23:02:43 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sh: intc_prio_data() test before subtraction on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bit is unsigned, so test before subtraction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/sh/kernel/cpu/irq/intc.c b/arch/sh/kernel/cpu/irq/intc.c
index 8c70e20..94536d3 100644
--- a/arch/sh/kernel/cpu/irq/intc.c
+++ b/arch/sh/kernel/cpu/irq/intc.c
@@ -464,9 +464,10 @@ static unsigned int __init intc_prio_data(struct intc_desc *desc,
 			}
 
 			fn += (pr->reg_width >> 3) - 1;
-			bit = pr->reg_width - ((j + 1) * pr->field_width);
 
-			BUG_ON(bit < 0);
+			BUG_ON((j + 1) * pr->field_width > pr->reg_width);
+
+			bit = pr->reg_width - ((j + 1) * pr->field_width);
 
 			return _INTC_MK(fn, mode,
 					intc_get_reg(d, reg_e),
@@ -531,9 +532,10 @@ static unsigned int __init intc_sense_data(struct intc_desc *desc,
 
 			fn = REG_FN_MODIFY_BASE;
 			fn += (sr->reg_width >> 3) - 1;
-			bit = sr->reg_width - ((j + 1) * sr->field_width);
 
-			BUG_ON(bit < 0);
+			BUG_ON((j + 1) * sr->field_width > sr->reg_width);
+
+			bit = sr->reg_width - ((j + 1) * sr->field_width);
 
 			return _INTC_MK(fn, 0, intc_get_reg(d, sr->reg),
 					0, sr->field_width, bit);
