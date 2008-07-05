Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbYGEL6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbYGEL6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYGEL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:21902 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYGEL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=NhMOAxnWbUofFAN5xo27S2Wq75WMwrD5DalTAQYNu4qB81GRj3LCc4SjMOCDhoaWKH
         GxcZhX3+YTw99MQRTRUEgl16/R2ZnNBPCUFg03s/B/0P5g7m7SVRwSIFtThSTKw0lLGt
         QB3eCesgvDm98Pvz3wMtzEcZTu1hLKbsWF0Sk=
References: <20080705115334.892720771@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 4/5] x86: smpboot maxcpus - add checking for NULL early param
Content-Disposition: inline; filename=ep-maxcpus
Message-ID: <486f61aa.1636440a.326b.ffffb954@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-06-28 21:15:44.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-07-05 12:53:28.000000000 +0400
@@ -1383,7 +1383,8 @@ static int __init parse_maxcpus(char *ar
 {
 	extern unsigned int maxcpus;
 
-	maxcpus = simple_strtoul(arg, NULL, 0);
+	if (arg)
+		maxcpus = simple_strtoul(arg, NULL, 0);
 	return 0;
 }
 early_param("maxcpus", parse_maxcpus);

-- 
