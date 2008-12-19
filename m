Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYLSSRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYLSSRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYLSSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:56 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50402 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbYLSSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:55 -0500
Subject: [PATCH 10/14] arm: Provide _sdata and __bss_stop in the vmlinux.lds.S
	file
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:13:52 +0000
Message-ID: <20081219181352.7778.13647.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:13:53.0313 (UTC) FILETIME=[8CC94910:01C96205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata and __bss_stop are common symbols defined by many architectures
and made available to the kernel via asm-generic/sections.h. Kmemleak
uses these symbols when scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 4898bdc..3cf1d44 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -120,6 +120,7 @@ SECTIONS
 
 	.data : AT(__data_loc) {
 		__data_start = .;	/* address in memory */
+		_sdata = .;
 
 		/*
 		 * first, the init task union, aligned
@@ -171,6 +172,7 @@ SECTIONS
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
 		*(COMMON)
+		__bss_stop = .;
 		_end = .;
 	}
 					/* Stabs debugging sections.	*/

