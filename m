Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbYBGAjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbYBGAjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932712AbYBGAH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:07:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:32237 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbYBGAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ad28M7k9wAAgB8tifdoG+ZOYvArqBh28FDWtw1qI2oJcfzZvVwU9LgLW7thkEIxqlXuF+L4Sq4K2hOPavTUlkeczYjgm2UUf0EPnShQeI3dzSt0MCDOE6yyTXg5y12L3b27ZJ8dvlQjQDNaHEYefa/RSaLAgNXgZvqVU9dZMAB0=
Subject: [PATCH 3/3] x86: sparse error in efi_32.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 16:07:49 -0800
Message-Id: <1202342869.5820.91.camel@brick>
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
1.5.4.1189.g38fd5

