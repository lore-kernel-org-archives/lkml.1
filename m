Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYFIUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYFIUI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYFIUH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:07:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:49749 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYFIUHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qwT+VQGljTNHFoz/ks0QtQ6mT75kxRLIpzOn8pdYjHWOF+QmdsGH3AeXHOaJVK16cv
         x2hSUcoweVEl1TxbNuqZAKotuWyhl2ueYlFUEf4pJUMqySIXRgUfUpQ9mfR0/Vqa/ceY
         Lx31CbfVHp08nXUBcRrwjEfJGANt2Lw/mPl5s=
Message-ID: <86802c440806091307r3c4d5e77h12e22abfe578769f@mail.gmail.com>
Date: Mon, 9 Jun 2008 13:07:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: reserve_bootmem_generic in early_res_to_bootmem
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can you make the 64 bit still use reserve_bootmem_generic in
early_res_to_bootmem?

reserve_bootmem_generic is some smart than reserve_bootmem when numa is enabled.

YH

commit 3f3040c347653b93e4e82ee45bb7d41f11c10be8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 9 15:12:20 2008 +0200

    x86: reserve highmem pages via reserve_early, fix #2

    fix:

    arch/x86/kernel/built-in.o: In function `early_res_to_bootmem':
    : undefined reference to `reserve_bootmem_generic'

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a488bd0..68aba41 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -635,7 +635,7 @@ void __init early_res_to_bootmem(u64 start, u64 end)
                        continue;
                printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
                        final_start, final_end - 1, r->name);
-               reserve_bootmem_generic(final_start, final_end - final_start,
+               reserve_bootmem(final_start, final_end - final_start,
                                BOOTMEM_DEFAULT);
        }
 }

commit df10637c5d57c2c1b42aeb2233e00da9764fd873
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 9 15:05:26 2008 +0200

    x86: reserve highmem pages via reserve_early, fix

    fix:

    arch/x86/kernel/e820.c: In function 'early_res_to_bootmem':
    arch/x86/kernel/e820.c:639: error: too few arguments to function
'reserve_bootmem_generic'

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a706e90..a488bd0 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -635,12 +635,8 @@ void __init early_res_to_bootmem(u64 start, u64 end)
                        continue;
                printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
                        final_start, final_end - 1, r->name);
-#ifdef CONFIG_X86_64
-               reserve_bootmem_generic(final_start, final_end - final_start);
-#else
-               reserve_bootmem(final_start, final_end - final_start,
+               reserve_bootmem_generic(final_start, final_end - final_start,
                                BOOTMEM_DEFAULT);
-#endif
        }
 }
