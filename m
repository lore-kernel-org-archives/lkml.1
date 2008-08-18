Return-Path: <linux-kernel-owner+w=401wt.eu-S1764111AbYHRTPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764111AbYHRTPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbYHRTMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:12:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:15712 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524AbYHRTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dVQMcoKDHr8BvF6O3mUGNSbL7al8hQnpMQlQKr17b2HnEBGOYv+Y+sS8gcFg69XQU+
         pXRNBphrO/lvU8qOnpmGMjKE2zvS+DDai42rGMLfXBSLnm/mGx9zG9lIuCC/QwFPmRRA
         ayhim51CubRD/9wYLjDrxzkgdm5v4yoxVFCq8=
Date: Mon, 18 Aug 2008 23:12:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, macro@linux-mips.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] apic: unification series 5
Message-ID: <20080818191233.GA31466@lenovo>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com> <48A9AFC4.8060505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A9AFC4.8060505@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Mon, Aug 18, 2008 at 10:22:12AM -0700]
> Cyrill Gorcunov wrote:
>>
>> With this series 32bit code compilation warns:
>>
>> arch/x86/kernel/apic_32.c: In function ‘end_local_APIC_setup’:
>> arch/x86/kernel/apic_32.c:1165: warning: ISO C90 forbids mixed declarations and code
>> arch/x86/kernel/apic_32.c: In function ‘disconnect_bsp_APIC’:
>> arch/x86/kernel/apic_32.c:1446: warning: ISO C90 forbids mixed declarations and code
>> cyrill@lenovo linux-2.6.git $ 
>>
>> So parenthesis will be needed to eliminate them... but
>> I think it could be too ugly... need some time to think.
>> So patches 8/15 and 10/15 sould be not applied for now - just review them.
>> Thanks for patience!
>>
>
> Typically, just move the declaration to the top of the function  
> (followed by a blank line.)
>
> 	-hpa
>
Here is compilation warnings fix

		- Cyrill -
---
x86: apic - compilation wrnings fix

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please check if it's not worse code form now :)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index e975562..b8d80c2 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1162,11 +1162,13 @@ void __cpuinit end_local_APIC_setup(void)
 	lapic_setup_esr();
 
 #ifdef CONFIG_X86_32
-	unsigned int value;
-	/* Disable the local apic timer */
-	value = apic_read(APIC_LVTT);
-	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-	apic_write(APIC_LVTT, value);
+	{
+		unsigned int value;
+		/* Disable the local apic timer */
+		value = apic_read(APIC_LVTT);
+		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, value);
+	}
 #endif
 
 	setup_apic_nmi_watchdog(NULL);
@@ -1426,6 +1428,8 @@ void __init connect_bsp_APIC(void)
  */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+	unsigned int value;
+
 #ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
@@ -1443,7 +1447,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 #endif
 
 	/* Go back to Virtual Wire compatibility mode */
-	unsigned int value;
 
 	/* For the spurious interrupt use vector F, and enable it */
 	value = apic_read(APIC_SPIV);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 7a31718..37e0376 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1020,11 +1020,13 @@ void __cpuinit end_local_APIC_setup(void)
 	lapic_setup_esr();
 
 #ifdef CONFIG_X86_32
-	unsigned int value;
-	/* Disable the local apic timer */
-	value = apic_read(APIC_LVTT);
-	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-	apic_write(APIC_LVTT, value);
+	{
+		unsigned int value;
+		/* Disable the local apic timer */
+		value = apic_read(APIC_LVTT);
+		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, value);
+	}
 #endif
 
 	setup_apic_nmi_watchdog(NULL);
@@ -1363,6 +1365,8 @@ void __init connect_bsp_APIC(void)
  */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+	unsigned int value;
+
 #ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
@@ -1380,7 +1384,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 #endif
 
 	/* Go back to Virtual Wire compatibility mode */
-	unsigned int value;
 
 	/* For the spurious interrupt use vector F, and enable it */
 	value = apic_read(APIC_SPIV);
