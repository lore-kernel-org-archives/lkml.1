Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYGEL7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYGEL7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGEL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:23988 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYGEL5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=OlpGYi6bazCQEtPp4MCxv5pZ3Y7WT+WHAF/o6G3ISNly5TfKNd1fI9FhFBf3CpAIq/
         jvSEGLCsLO1O1q7bmCZ1yj4TZUsPPptRWI651aYRgd6+3KESHryPMhbZtDAeRO3PYpbd
         NBBYv7gkpRaUkpKIwosr5lv1A9UnxTHN6ZZfM=
References: <20080705115334.892720771@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 5/5] x86: e820 memmap - add checking for NULL early param
Content-Disposition: inline; filename=ep-memmap
Message-ID: <486f61ac.2834440a.3f3c.ffffc33a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/e820.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/e820.c	2008-06-28 21:15:44.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/e820.c	2008-07-05 12:55:55.000000000 +0400
@@ -1131,6 +1131,9 @@ static int __init parse_memmap_opt(char 
 	char *oldp;
 	u64 start_at, mem_size;
 
+	if (!p)
+		return -EINVAL;
+
 	if (!strcmp(p, "exactmap")) {
 #ifdef CONFIG_CRASH_DUMP
 		/*

-- 
