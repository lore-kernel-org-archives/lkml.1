Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYBMV0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYBMV0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYBMV0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:26:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:61475 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYBMV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QfW0tGFz3gXACE32bOXuvhiuRj2YIZvpVPu/FKnAAYr3Y2g09yhzO4wLYGXLrm+hN3rMYVHg/0syPfv23l1hZqQ0UYayTbQyPsLhLD+/rs+YLaLAncCIPIn1Ljw6qhdeQIcUtbVdpSCC7UoD8HQDbPqvoVs47nbo5TILphQSQsU=
Subject: [PATCH 2/2] x86: sparse error in efi_32.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 13:26:39 -0800
Message-Id: <1202937999.18204.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/efi.h does not include asm/efi.h, efi.c and efi_64.c
explicitly include both.  While not really right, add the include
to efi_32.c until the header gets sorted out.

arch/x86/kernel/efi_32.c:42:6: warning: symbol 'efi_call_phys_prelog' was not declared. Should it be static?
arch/x86/kernel/efi_32.c:84:6: warning: symbol 'efi_call_phys_epilog' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/efi_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index cb91f98..5d23d85 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -28,6 +28,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/efi.h>
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
-- 
1.5.4.1.1278.gc75be

