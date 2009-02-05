Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbZBER3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbZBER3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbZBER30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:29:26 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:55491 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZBER30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Q4OVXCPqTYtQTzU+h332ULWLDoumyu1djP2x6DToRnJci+iTMNfS/wf/T5Uqq5PIQs
         8WTiYqvDlsniGnjYZRj8lbinnU6z5V39VHWqtUJbot1VYsMdh+3bjXF0iDLxzBy24b7H
         lD6RS9p477jg+DxI1KPtEQZDLJag+3i/Q6TiU=
MIME-Version: 1.0
Date: Fri, 6 Feb 2009 02:29:24 +0900
Message-ID: <703a7cde0902050929s200cd6a4m95f32aa9c93293ad@mail.gmail.com>
Subject: [PATCH] [ARM] Fix condition in arm_elf_read_implies_exec() to set 
	READ_IMPLIES_EXEC
From: Makito SHIOKAWA <lkhmkt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

READ_IMPLIES_EXEC must be set when binary _is an executable stack_
(i.e. not EXSTACK_DISABLE_X).

Signed-off-by: Makito SHIOKAWA <lkhmkt@gmail.com>
---
 arch/arm/kernel/elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(elf_set_personality);
  */
 int arm_elf_read_implies_exec(const struct elf32_hdr *x, int executable_stack)
 {
-	if (executable_stack != EXSTACK_ENABLE_X)
+	if (executable_stack != EXSTACK_DISABLE_X)
 		return 1;
 	if (cpu_architecture() <= CPU_ARCH_ARMv6)
 		return 1;
