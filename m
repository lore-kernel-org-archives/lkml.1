Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbYBVT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbYBVT7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYBVT6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:58:52 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44790 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbYBVT6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:58:51 -0500
Date: Fri, 22 Feb 2008 21:58:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make watchdog/hpwdt.c:asminline_call() static
Message-ID: <20080222195802.GA1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global asminline_call() static and 
removes the not required "asmlinkage".

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/watchdog/hpwdt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

83ff67cb18105141ba2f4a9eeb5e63d5ff0818ee diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..d14cfee 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -198,8 +198,8 @@ static int __devinit bios_checksum(const char __iomem *ptr, int len)
 
 #define HPWDT_ARCH	32
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
+static void asminline_call(struct cmn_registers *pi86Regs,
+			   unsigned long *pRomEntry)
 {
 	asm("pushl       %ebp               \n\t"
 	    "movl        %esp, %ebp         \n\t"
@@ -368,8 +368,8 @@ static int __devinit detect_cru_service(void)
 
 #define HPWDT_ARCH	64
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
+static void asminline_call(struct cmn_registers *pi86Regs,
+			   unsigned long *pRomEntry)
 {
 	asm("pushq      %rbp            \n\t"
 	    "movq       %rsp, %rbp      \n\t"

