Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbXIXLFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbXIXLFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbXIXLFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:05:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXIXLFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:05:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86_64 vDSO: put vars in .rodata
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070924110458.E48994D0325@magilla.localdomain>
Date: Mon, 24 Sep 2007 04:04:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds a const to the definitions vvar.c makes, so that the vdso_*
variables go into .rodata instead of .data.  This is essentially a cosmetic
change, just giving the section headers in the vDSO file more pleasing flags.
These variables are read-only from the perspective of the vDSO itself and
user mode, even though the contents of the DSO image were adjusted at boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/vdso/vvar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/vdso/vvar.c b/arch/x86_64/vdso/vvar.c
index 6fc2221..1b7e703 100644
--- a/arch/x86_64/vdso/vvar.c
+++ b/arch/x86_64/vdso/vvar.c
@@ -8,5 +8,5 @@
 #include <asm/timex.h>
 #include <asm/vgtod.h>
 
-#define VEXTERN(x) typeof (__ ## x) *vdso_ ## x = (void *)VMAGIC;
+#define VEXTERN(x) typeof (__ ## x) *const vdso_ ## x = (void *)VMAGIC;
 #include "vextern.h"
