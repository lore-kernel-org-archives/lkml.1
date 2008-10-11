Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbYJKGqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbYJKGqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYJKGiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:22 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYJKGhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:31 -0400
Date: Sat, 11 Oct 2008 02:36:16 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 56/85] x86: trim ACPI sleep stack buffer
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Len Brown <len.brown@intel.com>
Message-id: <5000cadcf3188e935dae28c4fc7e24639704ea55.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

x86_64 SMP suspend to RAM uses a 10k temporary stack for saving the
kernel state, but only 4k of it is used. Shrink it to 4k.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 29cf340..55d10cb 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -21,7 +21,7 @@ unsigned long acpi_realmode_flags;
 static unsigned long acpi_realmode;
 
 #if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
-static char temp_stack[10240];
+static char temp_stack[4096];
 #endif
 
 /**
-- 
1.5.5.1

