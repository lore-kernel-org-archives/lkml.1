Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbYCGS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbYCGS2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762833AbYCGS0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:26:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:23933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762795AbYCGS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Zi9Pt6uXOqFZOsJKPsQ27cQol9pIjzgxU0UMTF0a8gofVU5LQmgOjnjoLz0PX5kSw6uabIPVPTBc0/onDVIPbZ99xEbWH1jRcZZQR2OtF7/6hcp2ZpKtXLwzT5W6ZjLLeOu+KES/mkV1g91sqURjbt+I2GBEZJVxUrDwM/JTnbw=
Date: Fri, 7 Mar 2008 19:26:26 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: coding style fixes to arch/x86/kernel/setup_32.c
Message-ID: <20080307192626.4673455b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix one:
ERROR: do not initialise externals to 0 or NULL

The change affects the generated binary file:

paolo@paolo-desktop:/tmp/a$ size setup_32.o*
   text    data     bss     dec     hex filename
   3526    7406     885   11817    2e29 setup_32.o
   3526    7406     885   11817    2e29 setup_32.o.after
   3526    7410     885   11821    2e2d setup_32.o.after.initialise

paolo@paolo-desktop:/tmp/a$ md5sum setup_32.o*
d238f977facb3b4e4ee6a18390678376  setup_32.o
d238f977facb3b4e4ee6a18390678376  setup_32.o.after
1c43448c2f50d22215857741ffe5eca5  setup_32.o.after.initialise



Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/setup_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index b120a1c..029354b 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -228,7 +228,7 @@ static inline void copy_edd(void)
 }
 #endif
 
-int __initdata user_defined_memmap = 0;
+int __initdata user_defined_memmap;
 
 /*
  * "mem=nopentium" disables the 4MB page tables.
-- 
1.5.4.2.316.gf7a7

