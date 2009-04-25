Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZDYAOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZDYAOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZDYAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:14:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbZDYAOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:14:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 14/17] arm: user_regset: Crunch in core dumps
Message-Id: <20090425001354.88C42FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:13:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables dumping the Crunch state in ELF core dumps.
It gets its own note of the new type NT_ARM_CRUNCH.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |    1 +
 include/linux/elf.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 78b457c..6ce3deb 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -847,6 +847,7 @@ static const struct user_regset arm_regsets[] = {
 #endif
 #ifdef CONFIG_CRUNCH
 	[REGSET_CRUNCH] = {
+		.core_note_type = NT_ARM_CRUNCH,
 		.n = sizeof(struct crunch_state) / sizeof(int),
 		.size = sizeof(int), .align = sizeof(int),
 		.get = crunch_get, .set = crunch_set
diff --git a/include/linux/elf.h b/include/linux/elf.h
index aa8bae6..30a7b92 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -362,6 +362,7 @@ typedef struct elf64_shdr {
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
 #define NT_ARM_WMMX	0x300		/* ARM iWMMXt registers */
+#define NT_ARM_CRUNCH	0x301		/* ARM Crunch registers */
 
 
 /* Note header in a PT_NOTE section */
