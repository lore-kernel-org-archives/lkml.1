Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYJZThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYJZThp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYJZThg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:37:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYJZThf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:37:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86 suspend: Sanitize wakeup_64.S
Date: Sun, 26 Oct 2008 20:42:19 +0100
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810262042.20295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please queue as .29 material.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: x86 suspend: Sanitize wakeup_64.S

Segment registers are already set by head_64.S, which jumps into
wakeup_64.S, to the same values that wakeup_64.S wants them to
contain.  Remove the unnecessary initialization of segment registers
from wakeup_64.S.

Add hlt into the endless loop under bogus_64_magic.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/wakeup_64.S |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index bcc2934..0c5bf2f 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -19,12 +19,6 @@ wakeup_long64:
 	cmpq	%rdx, %rax
 	jne	bogus_64_magic
 
-	movw	$__KERNEL_DS, %ax
-	movw	%ax, %ss	
-	movw	%ax, %ds
-	movw	%ax, %es
-	movw	%ax, %fs
-	movw	%ax, %gs
 	movq	saved_rsp, %rsp
 
 	movq	saved_rbx, %rbx
@@ -36,6 +30,7 @@ wakeup_long64:
 	jmp	*%rax
 
 bogus_64_magic:
+	hlt
 	jmp	bogus_64_magic
 
 	.align 2
-- 
1.5.6

