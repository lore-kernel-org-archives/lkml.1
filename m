Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZAKMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZAKMYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZAKMYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:24:04 -0500
Received: from web.keli.cz ([77.48.235.227]:44650 "EHLO web.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZAKMYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:24:03 -0500
Message-ID: <4969E4D7.5050802@century.cz>
Date: Sun, 11 Jan 2009 13:23:51 +0100
From: Petr Titera <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc1
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunatelly it cannot be built without SMP support. This patch seems 
to fix it:

diff --git a/include/linux/smp.h b/include/linux/smp.h
index b824669..fd51bb9 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -11,6 +11,8 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 
+#include <asm/smp.h>
+
 extern void cpu_idle(void);
 
 struct call_single_data {
@@ -30,7 +32,6 @@ extern unsigned int total_cpus;
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
-#include <asm/smp.h>
 
 /*
  * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.



Petr Titera
