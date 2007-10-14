Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXJNT24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXJNT24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXJNT2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:28:49 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:57681 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXJNT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:28:48 -0400
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <19A5EC31-F1DF-40DB-B6D5-D3F3972426B0@screamingdolphin.net>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Doug Whitesell (LKML)" <dcw-kernel@screamingdolphin.net>
Subject: [PATCH] Include asm/vsyscall.h in arch/x86/kernel/alternative.c.
Date: Sun, 14 Oct 2007 12:26:47 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The VSYSCALL_START and VSYSCALL_END symbols are referenced in
apply_alternatives(), but vsyscall.h is not always included when
building on x86-64 with random configurations. Including asm/vsyscall.h
guarantees availability of the symbols, and is otherwise harmless.

Signed-off-by: Doug Whitesell <dcw-kernel@screamingdolphin.net>
---
arch/x86/kernel/alternative.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/ 
alternative.c
index bd72d94..cdb3e25 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -10,7 +10,7 @@
#include <asm/pgtable.h>
#include <asm/mce.h>
#include <asm/nmi.h>
-
+#include <asm/vsyscall.h>
#define MAX_PATCH_LEN (255-1)
#ifdef CONFIG_HOTPLUG_CPU
--
1.5.2.5

