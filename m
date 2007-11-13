Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXKMWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXKMWGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXKMWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:06:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48659 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759888AbXKMWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:06:21 -0500
Date: Wed, 14 Nov 2007 09:06:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc2-git3 powerpc link failure
Message-Id: <20071114090624.2a6aef50.sfr@canb.auug.org.au>
In-Reply-To: <473984E2.1040006@linux.vnet.ibm.com>
References: <473984E2.1040006@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On Tue, 13 Nov 2007 16:35:06 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
> The 2.6.24-rc2-git3 kernel build fails during linking 
> 
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      .tmp_vmlinux3
>   KSYM    .tmp_kallsyms3.S
>   AS      .tmp_kallsyms3.o
>   LD      vmlinux.o
> ld: TOC section size exceeds 64k
> make: *** [vmlinux.o] Error 1

You need the following patch.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Nov 2007 11:56:48 +1100
Subject: [PATCH] [POWERPC] Stop the TOC overflowing for large builds.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ca51f0c..9374bc9 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS	+= -mno-minimal-toc
+CFLAGS_prom_init.o	+= -mno-minimal-toc
 endif
 ifeq ($(CONFIG_PPC32),y)
 CFLAGS_prom_init.o      += -fPIC
-- 
1.5.3.5

