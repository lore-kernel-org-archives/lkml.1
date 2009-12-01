Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZLAJCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZLAJCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 04:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZLAJCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 04:02:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61662 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZLAJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 04:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WB0hzyO9N2gnqgclZ4JmRwHiQ4k7fqqZqBZstKM76K1FRAyZkGVkp81TgXzqqrKL/F
         ocdpau+2zRPdjb3A0/rih+oIht9ll0H6qk9u7X1HCdS12q0OV4+LuqVa08zGrRxLFvuj
         mqWMgE3DfJNPInhP97XqwZL3c+6Yzb6h0I5ZQ=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 15:02:56 +0600
Message-ID: <b9df5fa10912010102p405b429dg102843fe88932b9d@mail.gmail.com>
Subject: [PATCH] ip2: Remove #ifdef MODULE from ip2main.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ip2: Remove #ifdef MODULE completely.

>From kernel command line we can pass "module parameters".
So #ifdef MODULE is obsolute now. Remove it completely.
When CONFIG_PCI=n and building ip2main.c then we are hit
by the following warning. So move *pdev into #ifdef CONFIG_PCI.

drivers/char/ip2/ip2main.c: In function `ip2_loadmain':
drivers/char/ip2/ip2main.c:542: warning: unused variable `pdev'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/char/ip2/ip2main.c	2009-12-01 12:41:53.000000000 +0600
+++ rakib/drivers/char/ip2/ip2main.c	2009-12-01 12:56:56.000000000 +0600
@@ -263,7 +263,7 @@ static int tracewrap;
 /* Macros */
 /**********/

-#if defined(MODULE) && defined(IP2DEBUG_OPEN)
+#ifdef IP2DEBUG_OPEN
 #define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] ttyc=%d, modc=%x -> %s\n", \
 		    tty->name,(pCh->flags), \
 		    tty->count,/*GET_USE_COUNT(module)*/0,s)
@@ -487,7 +487,6 @@ static const struct firmware *ip2_reques
 	return fw;
 }

-#ifndef MODULE
 /******************************************************************************
  *	ip2_setup:
  *		str: kernel command line string
@@ -531,7 +530,6 @@ static int __init ip2_setup(char *str)
 	return 1;
 }
 __setup("ip2=", ip2_setup);
-#endif /* !MODULE */

 static int __init ip2_loadmain(void)
 {
@@ -539,7 +537,6 @@ static int __init ip2_loadmain(void)
 	int err = 0;
 	i2eBordStrPtr pB = NULL;
 	int rc = -1;
-	struct pci_dev *pdev = NULL;
 	const struct firmware *fw = NULL;

 	if (poll_only) {
@@ -612,6 +609,7 @@ static int __init ip2_loadmain(void)
 		case PCI:
 #ifdef CONFIG_PCI
 		{
+			struct pci_dev *pdev = NULL;
 			u32 addr;
 			int status;
