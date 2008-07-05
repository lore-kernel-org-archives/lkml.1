Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYGEL5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYGEL5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYGEL5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:22338 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYGEL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=o+EoC1r/3dWVqS9HByKXAOMA0vOW1NJMN5CRmmJOLv7UZrY2XcfRD/UuV/SXf0oLL8
         bBP8zstrw80vMfM9bZcYmA3BNvcNJLwugp01/aKAFW+nUjfQyPdmZAefihqh2OPtoM7v
         f5UVIHoW6LKpj8QOpXU+kgrFhLnlOovKfKDl0=
References: <20080705115334.892720771@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/5] x86: idle process - add checking for NULL early param
Content-Disposition: inline; filename=ep-idle
Message-ID: <486f61a9.1e35440a.57ee.ffffbe68@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/process.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/process.c	2008-06-28 21:15:44.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/process.c	2008-07-05 12:34:02.000000000 +0400
@@ -325,6 +325,9 @@ void __cpuinit select_idle_routine(const
 
 static int __init idle_setup(char *str)
 {
+	if (!str)
+		return -EINVAL;
+
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;

-- 
