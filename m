Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbZDXQrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbZDXQrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760401AbZDXQoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:44:21 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42113 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760585AbZDXQoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:44:20 -0400
Subject: [PATCH 10/14] arm: Provide _sdata and __bss_stop in the vmlinux.lds.S
	file
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Fri, 24 Apr 2009 17:41:54 +0100
Message-ID: <20090424164154.4476.20622.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:38.0829 (UTC) FILETIME=[ADC9D1D0:01C9C4FB]
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
index c90f272..6c07797 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -141,6 +141,7 @@ SECTIONS
 
 	.data : AT(__data_loc) {
 		_data = .;		/* address in memory */
+		_sdata = .;
 
 		/*
 		 * first, the init task union, aligned
@@ -192,6 +193,7 @@ SECTIONS
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
 		*(COMMON)
+		__bss_stop = .;
 		_end = .;
 	}
 					/* Stabs debugging sections.	*/

