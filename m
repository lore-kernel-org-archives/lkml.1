Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZEKMba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZEKMba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZEKMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:31:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZEKMbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:31:20 -0400
Date: Mon, 11 May 2009 12:30:32 GMT
From: tip-bot for Catalin Marinas <catalin.marinas@arm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       catalin.marinas@arm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       catalin.marinas@arm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
References: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
Subject: [tip:x86/kbuild] x86: Provide _sdata in the vmlinux.lds.S file
Message-ID: <tip-4504c6d020fc5aec7659bf7746e71b1b904571f8@git.kernel.org>
Git-Commit-ID: 4504c6d020fc5aec7659bf7746e71b1b904571f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 12:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4504c6d020fc5aec7659bf7746e71b1b904571f8
Gitweb:     http://git.kernel.org/tip/4504c6d020fc5aec7659bf7746e71b1b904571f8
Author:     Catalin Marinas <catalin.marinas@arm.com>
AuthorDate: Mon, 11 May 2009 13:22:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 14:28:55 +0200

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
 
