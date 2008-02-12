Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbYBLMbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbYBLMbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYBLMbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:31:09 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:46582 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYBLMbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:31:07 -0500
Message-ID: <47B191CF.7050409@larces.uece.br>
Date: Tue, 12 Feb 2008 09:32:15 -0300
From: Sergio Luis <sergio@larces.uece.br>
Reply-To: sergio@larces.uece.br
Organization: Ceara State University (UECE)
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Michal Januszewski <spock@gentoo.org>
Subject: [PATCH] 2.6.25-rc1-git2: drivers/video/uvesafb.c: fix section mismatch
 warning in param_set_scroll()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: drivers/video/built-in.o(.text+0x7c64a): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c65d): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c679): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c699): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c69f): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa3676): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa3689): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36a5): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36c5): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36cb): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a079a): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07ad): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07c9): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07e9): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07ef): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan

Remove __devinitdata annotation from the variable ypan.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>

uvesafb.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -urN linux-2.6.25-rc1-git2.orig/drivers/video/uvesafb.c linux-2.6.25-rc1-git2/drivers/video/uvesafb.c
--- linux-2.6.25-rc1-git2.orig/drivers/video/uvesafb.c	2008-02-12 09:26:15.000000000 -0300
+++ linux-2.6.25-rc1-git2/drivers/video/uvesafb.c	2008-02-12 08:52:20.000000000 -0300
@@ -44,7 +44,7 @@
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
-static int ypan		__devinitdata = 1; /* 0: scroll, 1: ypan, 2: ywrap */
+static int ypan		= 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
 static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */

