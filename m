Return-Path: <linux-kernel-owner+w=401wt.eu-S936156AbYBAHvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936156AbYBAHvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935379AbYBAHli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:38 -0500
Received: from rex.snapgear.com ([203.143.235.140]:45233 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935368AbYBAHlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:36 -0500
Date: Fri, 1 Feb 2008 17:40:52 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117eqZG022806@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 07/07]: remove dead timer int pending code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the dead timer interrupt checking functions for the ColdFire
CPU "timers" hardware that are not used after switching to GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

 5206/config.c  |   14 --------------
 5206e/config.c |   14 --------------
 5249/config.c  |   14 --------------
 5272/config.c  |   13 -------------
 5307/config.c  |   14 --------------
 532x/config.c  |   14 --------------
 5407/config.c  |   14 --------------
 7 files changed, 97 deletions(-)


diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5206/config.c linux-2.6.24.2/arch/m68knommu/platform/5206/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5206/config.c	2008-02-01 15:21:26.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5206/config.c	2008-02-01 16:13:27.000000000 +1000
@@ -109,20 +109,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = MCFSIM_IMR_TIMER1; break;
-	case 2:  imr = MCFSIM_IMR_TIMER2; break;
-	default: break;
-	}
-	return (mcf_getipr() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5206e/config.c linux-2.6.24.2/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5206e/config.c	2008-02-01 15:25:21.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5206e/config.c	2008-02-01 16:13:33.000000000 +1000
@@ -108,20 +108,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = MCFSIM_IMR_TIMER1; break;
-	case 2:  imr = MCFSIM_IMR_TIMER2; break;
-	default: break;
-	}
-	return (mcf_getipr() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5249/config.c linux-2.6.24.2/arch/m68knommu/platform/5249/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5249/config.c	2008-02-01 15:41:28.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5249/config.c	2008-02-01 16:13:40.000000000 +1000
@@ -105,20 +105,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = MCFSIM_IMR_TIMER1; break;
-	case 2:  imr = MCFSIM_IMR_TIMER2; break;
-	default: break;
-	}
-	return (mcf_getipr() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5272/config.c linux-2.6.24.2/arch/m68knommu/platform/5272/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5272/config.c	2008-02-01 15:44:22.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5272/config.c	2008-02-01 16:13:46.000000000 +1000
@@ -123,19 +123,6 @@ void mcf_settimericr(int timer, int leve
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	volatile unsigned long *icrp;
-
-	if ((timer >= 1 ) && (timer <= 4)) {
-		icrp = (volatile unsigned long *) (MCF_MBAR + MCFSIM_ICR1);
-		return (*icrp & (0x8 << ((4 - timer) * 4)));
-	}
-	return 0;
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 #if defined (CONFIG_MOD5272)
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5307/config.c linux-2.6.24.2/arch/m68knommu/platform/5307/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5307/config.c	2008-02-01 15:46:11.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5307/config.c	2008-02-01 16:13:51.000000000 +1000
@@ -119,20 +119,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = MCFSIM_IMR_TIMER1; break;
-	case 2:  imr = MCFSIM_IMR_TIMER2; break;
-	default: break;
-	}
-	return (mcf_getipr() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/532x/config.c linux-2.6.24.2/arch/m68knommu/platform/532x/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/532x/config.c	2008-02-01 15:16:22.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/532x/config.c	2008-02-01 16:13:57.000000000 +1000
@@ -116,20 +116,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = 0x1; break;
-	case 2:  imr = 0x2; break;
-	default: break;
-	}
-	return (mcf_getiprh() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
diff -Naurp linux-2.6.24.1/arch/m68knommu/platform/5407/config.c linux-2.6.24.2/arch/m68knommu/platform/5407/config.c
--- linux-2.6.24.1/arch/m68knommu/platform/5407/config.c	2008-02-01 15:19:27.000000000 +1000
+++ linux-2.6.24.2/arch/m68knommu/platform/5407/config.c	2008-02-01 16:14:02.000000000 +1000
@@ -110,20 +110,6 @@ void mcf_settimericr(unsigned int timer,
 
 /***************************************************************************/
 
-int mcf_timerirqpending(int timer)
-{
-	unsigned int imr = 0;
-
-	switch (timer) {
-	case 1:  imr = MCFSIM_IMR_TIMER1; break;
-	case 2:  imr = MCFSIM_IMR_TIMER2; break;
-	default: break;
-	}
-	return (mcf_getipr() & imr);
-}
-
-/***************************************************************************/
-
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
