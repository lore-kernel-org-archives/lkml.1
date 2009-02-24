Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZBYBNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZBYBNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZBYBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:12:26 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46992 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752358AbZBYBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:12:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Content-Disposition:From:Reply-To:Date:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=IIMvtRalMN5NwExiUIji/Ben72tD4x0YdX3WqfPFoGvbbnbM9PVx/pKemTRvShdD+VtGrfdXRK4I5/a0v5SJSvhy2MWtRiS0PBPyUNJgf1dhYXaN9I711ZWEnw1dxHAvgTBHXBkzthSpU+mm0jbdxHKwXWxfVLSsgDnVH8OIr0s=  ;
X-YMail-OSG: Qoi8.qcVM1mSyRJ2sOAnlDAVWHRYECHnT90nRBowst_YzAl33hAeYXwGaUYMu_T8K474qy8qPqXvc6VNRlFD8X7zKKTtsbCe8NdHYgkcg6E5cUl2RF50hzJVaCT7E6vL1fYmGN45_jVFQxkcqKOQZ7mELayns6ylCNz_ivYKl1gABIUQrLT2d07_1XGaM4kIsw--
X-Yahoo-Newman-Property: ymail-3
To: Linux MTD <linux-mtd@lists.infradead.org>
Subject: [patch/RESEND 2.6.29-rc3] MTD: we don't need no misc devices
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
Date: Tue, 24 Feb 2009 15:11:57 -0800
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902241511.57445.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Remove <linux/miscdevice.h> from various drivers which don't
actually use any of its contents.  There are still a number
of these left in arch-specific bits of the tree.

(Found by diffing results of "grep -rl" for linux/miscdevice.h
and for misc_register, examining the differences, and verifying
removals with a build test.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Random stuff that needs to be emptied from my patch queue.  :)

 drivers/mtd/devices/doc2000.c     |    1 -
 drivers/mtd/devices/doc2001.c     |    1 -
 drivers/mtd/devices/doc2001plus.c |    1 -
 drivers/mtd/devices/docecc.c      |    1 -
 drivers/mtd/inftlmount.c          |    1 -
 drivers/mtd/nftlcore.c            |    1 -
 6 files changed, 6 deletions(-)

--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -10,7 +10,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
--- a/drivers/mtd/devices/doc2001.c
+++ b/drivers/mtd/devices/doc2001.c
@@ -10,7 +10,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- a/drivers/mtd/devices/doc2001plus.c
+++ b/drivers/mtd/devices/doc2001plus.c
@@ -14,7 +14,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- a/drivers/mtd/devices/docecc.c
+++ b/drivers/mtd/devices/docecc.c
@@ -26,7 +26,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- a/drivers/mtd/inftlmount.c
+++ b/drivers/mtd/inftlmount.c
@@ -28,7 +28,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -15,7 +15,6 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
