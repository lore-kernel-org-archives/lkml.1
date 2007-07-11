Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXGKTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXGKTCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762983AbXGKTCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:02:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762056AbXGKTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:02:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/7] powerpc: Put allocated ELF notes in read-only data segment
X-Fcc: ~/Mail/linus
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070711190154.E64D64D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 12:01:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This changes the powerpc linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 21c39ff..7f0064d 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -62,6 +62,8 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
+	NOTES
+
 	BUG_TABLE
 
 /*
