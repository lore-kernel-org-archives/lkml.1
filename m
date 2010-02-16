Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0BPGom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:44:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40773 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0BPGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:44:40 -0500
Date: Tue, 16 Feb 2010 15:44:37 +0900 (JST)
Message-Id: <20100216.154437.193709505.d.hatayama@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: [PATCH, mmotm] compat_binfmt_elf.c: Use 32-bit section header, not
 64-bit one
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

From: akpm@linux-foundation.org
Subject: + elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:04:59 -0800

> 
> The patch titled
>      elf-coredump-replace-elf_core_extra_-macros-by-functions-fix
> has been added to the -mm tree.  Its filename is
>      elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
> 

I found that the previous fix patch of mine was insufficient for
fixing the problem relevant to EL32. It was necessary that one should
use the 32-bit datatype for section headers instead of the 64-bit one.
Here is a patch complementing it.

I made a runtime test for this fix patch, confirming that the
functionality works well.

Thanks,
HATAYAMA Daisuke

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
---
 fs/compat_binfmt_elf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 0adced2..112e45a 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -28,10 +28,12 @@
 
 #undef	elfhdr
 #undef	elf_phdr
+#undef	elf_shdr
 #undef	elf_note
 #undef	elf_addr_t
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Addr
 
-- 
1.6.5.1
