Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbZBQKRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbZBQKRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZBQKQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:16:53 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:60824 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZBQKQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:16:52 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: PROBLEM: incorrect interrupt ack  lead to interrupt loss on freescale powerpc
Date: Tue, 17 Feb 2009 18:16:46 +0800
Message-ID: <3A45394FD742FA419B760BB8D398F9ED246D03@zch01exm26.fsl.freescale.net>
In-Reply-To: <D728AD1FA2543948B89DE29C5BF4CD0716A9ADD8@bjmail1.bj.datangmobile.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM: incorrect interrupt ack  lead to interrupt loss on freescale powerpc
Thread-Index: AcmQ2n06DcXf5Ar+T+SgI94lU1s0UQADMFlQ
References: <D728AD1FA2543948B89DE29C5BF4CD0716A9ADD8@bjmail1.bj.datangmobile.com>
From: "Li Yang-R58472" <LeoLi@freescale.com>
To: <dayu@datangmobile.cn>, <linux-kernel@vger.kernel.org>
Cc: <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: dayu@datangmobile.cn [mailto:dayu@datangmobile.cn] 
> Sent: Tuesday, February 17, 2009 4:34 PM
> To: linux-kernel@vger.kernel.org
> Cc: Li Yang-R58472
> Subject: PROBLEM: incorrect interrupt ack lead to interrupt 
> loss on freescale powerpc
> 
>  
> [1.] One line summary of the problem: incorrect interrupt ack 
>  lead to interrupt loss

Acked-by: Li Yang <leoli@freescale.com>

However, please resend the patch with a brief description and Signed-off-by at the top of the patch.  You can read the Documentation/SubmittiongPatches for more information, or even a Chinese version under Documentation/zh_CN/.

Here are some small comments about the patch itself,

--- a/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:18.000000000 +0800
+++ b/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:24.000000000 +0800
@@ -9,6 +9,7 @@
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
+ * Da Yu <dayu@datangmobile.cn> fixed the interrupt loss problem on powerpc IPIC


It's not recommended to add changelog in the source now.  Please describe in the patch description area.

  */
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -561,8 +562,7 @@
 
 	spin_lock_irqsave(&ipic_lock, flags);
 
-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = (1 << (31 - ipic_info[src].bit));


Remove unneeded brackets.


 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
 
 	spin_unlock_irqrestore(&ipic_lock, flags);
@@ -581,8 +581,7 @@
 	temp &= ~(1 << (31 - ipic_info[src].bit));
 	ipic_write(ipic->regs, ipic_info[src].mask, temp);
 
-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = (1 << (31 - ipic_info[src].bit));

Same as above.


 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
 
 	spin_unlock_irqrestore(&ipic_lock, flags);
