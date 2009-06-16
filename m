Return-Path: <linux-kernel-owner+w=401wt.eu-S1763755AbZFPUTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763755AbZFPUTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbZFPUQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:18 -0400
Received: from claw.goop.org ([74.207.240.146]:40600 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbZFPUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 02/16] x86: Provide _sdata in the vmlinux.lds.S file
Date: Tue, 16 Jun 2009 13:15:41 -0700
Message-Id: <1245183355-25808-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

_sdata is a common symbol defined by many architectures and made
available to the kernel via asm-generic/sections.h. Kmemleak uses this
symbol when scanning the data sections.

[ Impact: add new global symbol ]

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
LKML-Reference: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4c85b2e..367e878 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -108,6 +108,8 @@ SECTIONS
 	/* Data */
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		/* Start of data section */
+		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
 
-- 
1.6.2.2

