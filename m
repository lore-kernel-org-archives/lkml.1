Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYJAGhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYJAGhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYJAGgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:36:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYJAGgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:36:52 -0400
Date: Wed, 1 Oct 2008 08:36:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: change MTRR_SANITIZER to def_bool y
Message-ID: <20081001063632.GA30756@elte.hu>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com> <1222817380-29481-3-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222817380-29481-3-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied the patch below to tip/x86/mtrr, thanks Yinghai!

(i'll wait for v2 of the mtrr parameter documentation patches.)

	Ingo

---------------------->
>From 2ffb3501f6f356ff80e7149214bc64d3fa9021c4 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Tue, 30 Sep 2008 16:29:40 -0700
Subject: [PATCH] x86: change MTRR_SANITIZER to def_bool y

This option has been added in v2.6.26 as a default-disabled
feature and went through several revisions since then.

The feature fixes a wide range of MTRR setup problems that BIOSes
leave us with: slow system, slow Xorg, slow system when adding lots
of RAM, etc., so we want to enable it by default for v2.6.28.

See:

  [Bug 10508] Upgrade to 4GB of RAM messes up MTRRs
  http://bugzilla.kernel.org/show_bug.cgi?id=10508

and the test results in:

   http://lkml.org/lkml/2008/9/29/273

1. hpa
reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x13c000000 (5056MB), size=  64MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 128M        num_reg: 6      lose RAM: 0M
range0: 0000000000000000 - 00000000c0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
range0: 0000000100000000 - 0000000140000000
Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB
hole: 000000013c000000 - 0000000140000000
Setting variable MTRR 5, base: 5056MB, range: 64MB, type UC

2. Dylan Taft
reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg02: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 4M  num_reg: 6      lose RAM: 0M
range0: 0000000000000000 - 00000000c8000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
hole: 00000000c7e00000 - 00000000c8000000
Setting variable MTRR 3, base: 3198MB, range: 2MB, type UC
rangeX: 0000000100000000 - 0000000130000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB

3. Gabriel
reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 16M         num_reg: 7      lose RAM: 0M
range0: 0000000000000000 - 00000000d0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
hole: 00000000cf600000 - 00000000cf800000
Setting variable MTRR 3, base: 3318MB, range: 2MB, type UC
rangeX: 0000000100000000 - 000000012c000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 128MB, type WB
Setting variable MTRR 6, base: 4736MB, range: 64MB, type WB

4. Mika Fischer
reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1

will get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 16M         num_reg: 5      lose RAM: 0M
range0: 0000000000000000 - 00000000c0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
hole: 00000000bf700000 - 00000000c0000000
Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
rangeX: 0000000100000000 - 0000000140000000
Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..09f6b7f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1120,7 +1120,7 @@ config MTRR
 	  See <file:Documentation/mtrr.txt> for more information.
 
 config MTRR_SANITIZER
-	bool
+	def_bool y
 	prompt "MTRR cleanup support"
 	depends on MTRR
 	help
@@ -1131,7 +1131,7 @@ config MTRR_SANITIZER
 	  The largest mtrr entry size for a continous block can be set with
 	  mtrr_chunk_size.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config MTRR_SANITIZER_ENABLE_DEFAULT
 	int "MTRR cleanup enable value (0-1)"
