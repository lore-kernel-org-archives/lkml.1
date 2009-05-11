Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZEKMZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZEKMZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZEKMYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:24:52 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51327 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbZEKMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:24:52 -0400
Subject: [PATCH] x86: Provide _sdata in the vmlinux.lds.S file
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Date: Mon, 11 May 2009 13:22:00 +0100
Message-ID: <20090511122105.26556.96593.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.375.gd335
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2009 12:23:38.0028 (UTC) FILETIME=[4FC586C0:01C9D233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata is a common symbol defined by many architectures and made
available to the kernel via asm-generic/sections.h. Kmemleak uses this
symbol when scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

(This patch is against the tip/master branch)

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
 

