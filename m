Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZDYAMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZDYAMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZDYAMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:12:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbZDYAMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:12:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 10/17] arm: user_regset: VFP in core dumps
Message-Id: <20090425001209.206A6FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:12:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables dumping the VFP state in ELF core dumps.
It gets its own note.

I reused the NT_PRXFPREG type code already used for extended-FP
state on x86, because it seems to fit logically.  It would be just
as easy to define a new code called NT_ARM_VFP in linux/elf.h if
that is preferable.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 7f3c121..5fb5ac1 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -805,6 +805,7 @@ static const struct user_regset arm_regsets[] = {
 	},
 #ifdef CONFIG_VFP
 	[REGSET_VFP] = {
+		.core_note_type = NT_PRXFPREG,
 		.n = sizeof(struct user_vfp) / sizeof(long),
 		.size = sizeof(long), .align = sizeof(long),
 		.get = vfp_get, .set = vfp_set
