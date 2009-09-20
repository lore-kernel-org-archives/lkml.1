Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZITST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZITST6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZITSTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:19:55 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:56912 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZITSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Pyr1ZRcjPxrwutH4gZSqmZ87xj4obdzn7KzNNxw/IgGEU/W1Ih5bqE27qn5ZbEJeBW
         /+5CkSGGLW7NQ2Gt7CoEdLYFp91JKDjOyAfaHvGEnKT10FpSFSb7Zj3O4n94AK4CD9iU
         0jCWAwXhI8rIPWoJX1ATHv1Cp2y55Y01BeNS4=
Message-ID: <4AB6724A.1060702@gmail.com>
Date: Sun, 20 Sep 2009 12:19:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
CC: r.marek@assembler.cz
Subject: [PATCH] coretemp: add support for Core i5 CPU
References: <4AB5DE1F.1020004@gmail.com>
In-Reply-To: <4AB5DE1F.1020004@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add coretemp support for Core i5 (Lynnfield) CPUs with model 0x1E.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

---

This minimal patch works to add support for these CPUs, though we should likely
still look into using the CPUID flags instead of the model check.

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..a9a21dc 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -413,11 +413,11 @@ static int __init coretemp_init(void)
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
 
-		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A */
+		/* check if family 6, models 0xe, 0xf, 0x16, 0x17, 0x1A, 0x1E */
 		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
 		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
 			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-			(c->x86_model == 0x1A))) {
+			(c->x86_model == 0x1A) || (c->x86_model == 0x1E))) {
 
 			/* supported CPU not found, but report the unknown
 			   family 6 CPU */
