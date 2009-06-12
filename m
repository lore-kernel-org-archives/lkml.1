Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbZFLHco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbZFLHco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZFLHcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:32:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:49954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZFLHce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:32:34 -0400
Date: Fri, 12 Jun 2009 07:31:56 GMT
From: tip-bot for Catalin Marinas <catalin.marinas@arm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       catalin.marinas@arm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
References: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
Subject: [tip:x86/urgent] x86: Provide _sdata in the vmlinux.lds.S file
Message-ID: <tip-1260866a271abc84274345580f3d613d3bceff87@git.kernel.org>
Git-Commit-ID: 1260866a271abc84274345580f3d613d3bceff87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 07:31:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1260866a271abc84274345580f3d613d3bceff87
Gitweb:     http://git.kernel.org/tip/1260866a271abc84274345580f3d613d3bceff87
Author:     Catalin Marinas <catalin.marinas@arm.com>
AuthorDate: Mon, 11 May 2009 13:22:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 09:21:33 +0200

x86: Provide _sdata in the vmlinux.lds.S file

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
 
