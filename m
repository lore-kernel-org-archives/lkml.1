Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYFXQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYFXQUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFXQUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:36535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYFXQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=ISOXk7v075Ai+qE1c6lj3I00man+MNAjvLAQwdwHoyNNAi3rifeIj5TyBxkoFa0uKC
         NYdn/v8GUNAwTs7wdiITdroSJ47XOCjaTQ5avLVuSWz0mqJgznayUA8rQ+QFpWztxROJ
         SnidwPAax9doYAydn6DvQ+T8Fc5Nhf0k4z5Z8=
References: <20080624161624.124913675@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/5] x86: nmi_watchdog - remove useless check
Content-Disposition: inline; filename=nmi-reduce-check
Message-ID: <48611ec1.2234440a.679b.1a7c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nmi_watchdog is unsigned variable we may
safely remove the check for negative value

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-06-22 23:02:50.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-06-23 20:02:47.000000000 +0400
@@ -186,7 +186,7 @@ error:
 
 static int __init setup_nmi_watchdog(char *str)
 {
-	int nmi;
+	unsigned int nmi;
 
 	if (!strncmp(str, "panic", 5)) {
 		panic_on_timeout = 1;
@@ -198,7 +198,7 @@ static int __init setup_nmi_watchdog(cha
 
 	get_option(&str, &nmi);
 
-	if (nmi >= NMI_INVALID || nmi < NMI_NONE)
+	if (nmi >= NMI_INVALID)
 		return 0;
 
 	nmi_watchdog = nmi;

-- 
