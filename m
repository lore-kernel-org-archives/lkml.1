Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZGMQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZGMQ6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZGMQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:36623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZGMQ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:58:15 -0400
Date: Mon, 13 Jul 2009 16:57:41 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <b9df5fa10907120404k6279a10ch5e9682432272706f@mail.gmail.com>
References: <b9df5fa10907120404k6279a10ch5e9682432272706f@mail.gmail.com>
Subject: [tip:x86/urgent] x86: Fix false positive section mismatch in es7000_32.c
Message-ID: <tip-151586d0f70405d99324d89aea13706cf6d7f993@git.kernel.org>
Git-Commit-ID: 151586d0f70405d99324d89aea13706cf6d7f993
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Jul 2009 16:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  151586d0f70405d99324d89aea13706cf6d7f993
Gitweb:     http://git.kernel.org/tip/151586d0f70405d99324d89aea13706cf6d7f993
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sun, 12 Jul 2009 17:04:12 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Jul 2009 11:03:26 +0200

x86: Fix false positive section mismatch in es7000_32.c

The variable apic_es7000_cluster references the function __cpuinit
wakeup_secondary_cpu_via_mip() from a noninit section. So we've been
warned by the following warning. To avoid possible collision between
init/noninit, its best to mark the variable as __refdata.

We were warned by the following warning:

  LD      arch/x86/kernel/apic/built-in.o
  WARNING: arch/x86/kernel/apic/built-in.o(.data+0x198c): Section
  mismatch in reference from the variable apic_es7000_cluster to the
  function .cpuinit.text:wakeup_secondary_cpu_via_mip()

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
LKML-Reference: <b9df5fa10907120404k6279a10ch5e9682432272706f@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/es7000_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 69328ac..8952a58 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -652,7 +652,8 @@ static int es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem,
 	return ret && es7000_apic_is_cluster();
 }
 
-struct apic apic_es7000_cluster = {
+/* We've been warned by a false positive warning.Use __refdata to keep calm. */
+struct apic __refdata apic_es7000_cluster = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
