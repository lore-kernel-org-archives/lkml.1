Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZDYALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZDYALs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZDYALX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:11:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZDYALW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:11:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 08/17] arm: CORE_DUMP_USE_REGSET
Message-Id: <20090425001113.9C344FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:11:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip on CORE_DUMP_USE_REGSET now that arm has user_regset support
for the general and FPU register sets that appear in core dumps.

This moves arm in line with the preferred new code to gather
registers for ELF core dumps.  There is no material change to
what appears in core dumps.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/include/asm/elf.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index d7da19b..97a1cd2 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -94,6 +94,7 @@ extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)
 
 #define USE_ELF_CORE_DUMP
+#define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
