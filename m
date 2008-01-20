Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYATEmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYATEmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 23:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYATEmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 23:42:42 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45072 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYATEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 23:42:41 -0500
Date: Sat, 19 Jan 2008 20:45:16 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: disable_mtrr_trim only need for x86_64
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200801192045.17291.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: disable_mtrr_trim only need for x86_64

mtrr_trim_uncached_memory is only used in x86_64,

so disable_mtrr_trim is not needed for x86_32

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 46763e3..608c88a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -624,6 +624,7 @@ static struct sysdev_driver mtrr_sysdev_driver = {
 	.resume		= mtrr_restore,
 };
 
+#ifdef CONFIG_X86_64
 static int disable_mtrr_trim;
 
 static int __init disable_mtrr_trim_setup(char *str)
@@ -633,7 +634,6 @@ static int __init disable_mtrr_trim_setup(char *str)
 }
 early_param("disable_mtrr_trim", disable_mtrr_trim_setup);
 
-#ifdef CONFIG_X86_64
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
  *
