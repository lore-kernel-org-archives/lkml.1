Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXB0XM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXB0XM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXB0XM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:12:59 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38506
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXB0XM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:12:58 -0500
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: Menuconfig has butterfly effects?
Date: Tue, 27 Feb 2007 18:12:42 -0500
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702271812.42616.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I ran "make ARCH=x86_64 menuconfig", did a lot of editing, and saved 
the .config.  Then I copied that to a backup, ran "make oldconfig" on the 
config I'd just saved, and compared it with the backup:

--- .config     2007-02-27 18:10:01.000000000 -0500
+++ tryit       2007-02-27 18:09:09.000000000 -0500
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.20
-# Tue Feb 27 18:10:01 2007
+# Tue Feb 27 18:08:41 2007
 #
 CONFIG_X86_64=y
 CONFIG_64BIT=y
@@ -120,6 +120,9 @@
 # CONFIG_PREEMPT_VOLUNTARY is not set
 # CONFIG_PREEMPT is not set
 CONFIG_ARCH_FLATMEM_ENABLE=y
+# CONFIG_FLATMEM_MANUAL is not set
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set

The first hunk I expect, the second I did not.  Anybody care to venture a 
guess why the visibility logic is unstable?

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
