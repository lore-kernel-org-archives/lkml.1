Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYDGHL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYDGHL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYDGHLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:11:48 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:42867 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYDGHLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:11:48 -0400
Date: Sat, 5 Apr 2008 13:48:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com, zippel@linux-m68k.org,
       linux-ext4@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: ext4 compile error on m68k
In-Reply-To: <20080405102408.GB30987@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804051345180.7216@anakin>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008, Adrian Bunk wrote:
> Commit aa02ad67d9b308290fde390682cd039b29f7ab85
> "ext4: Add ext4_find_next_bit()" causes the following regression:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  fs/ext4/mballoc.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c:696: error: implicit declaration of function 'generic_find_next_le_bit'
> make[3]: *** [fs/ext4/mballoc.o] Error 1
> 
> <--  snip  -->

Known issue. The ext4 developers added a #define (with a different name than in
the patch comment) in the commit below, but forgot to make sure
generic_find_next_le_bit() is actually available.

commit aa02ad67d9b308290fde390682cd039b29f7ab85
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Mon Jan 28 23:58:27 2008 -0500

    ext4: Add ext4_find_next_bit()
    
    This function is used by the ext4 multi block allocator patches.
    
    Also add generic_find_next_le_bit
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Cc: <linux-ext4@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 2976b5d..83d1f28 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -410,6 +410,8 @@ static inline int ext2_find_next_zero_bit(const void *vaddr
        res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
        return (p - addr) * 32 + res;
 }
+#define ext2_find_next_bit(addr, size, off) \
+       generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* __KERNEL__ */


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
