Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYHHQny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYHHQny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYHHQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:43:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:50546 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497AbYHHQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:43:40 -0400
Message-ID: <489C77C6.7040408@keyaccess.nl>
Date: Fri, 08 Aug 2008 18:43:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Content-Type: multipart/mixed;
 boundary="------------000805010409050308080704"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000805010409050308080704
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

<repeat below changelog>

Rene.

--------------000805010409050308080704
Content-Type: text/plain;
 name="0001-x86-kill-arch-x86-kernel-mpparse.c-debugging-printk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-kill-arch-x86-kernel-mpparse.c-debugging-printk.pat";
 filename*1="ch"

>From 00acea21e579ea0853baba25420f373ea83533a3 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@keyaccess.nl>
Date: Thu, 7 Aug 2008 01:50:35 +0200
Subject: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.

commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly
nopped debugging printks in arch/x86/kernel/mppparse.c into regular
ones. The one at the top of smp_scan_config() in particular also
prints on !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines
without anything resembling MP tables which makes their lowly UP
owners wonder...

given that it was up to this point also not considered valuable
user-level information, let's just kill that one.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/kernel/mpparse.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6ae005c..519a6a9 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -695,7 +695,6 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
-- 
1.5.5


--------------000805010409050308080704--
