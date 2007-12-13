Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbXLMHHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbXLMHHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762258AbXLMG4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55313 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762215AbXLMG4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:53 -0500
Date: Wed, 12 Dec 2007 22:52:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Michael Tokarev <mjt@tls.msk.ru>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 27/60] x86 setup: add a near jump to serialize %cr0 on
	386/486
Message-ID: <20071213065217.GB6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-setup-add-a-near-jump-to-serialize-cr0-on-386-486.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: H. Peter Anvin <hpa@zytor.com>

patch 7ed192906a2144ebc8ca2925a85d27b9c5355668 in mainline.

The 386 and 486 needs a jump immediately after setting %cr0 in order
to serialize the pipeline.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/boot/pmjump.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/i386/boot/pmjump.S
+++ b/arch/i386/boot/pmjump.S
@@ -31,14 +31,14 @@ protected_mode_jump:
 	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
 	movl	%eax, 2f		# Patch ljmpl instruction
-	jmp	1f			# Short jump to flush instruction q.
 
-1:
 	movw	$__BOOT_DS, %cx
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	jmp	1f			# Short jump to serialize on 386/486
+1:
 
 	movw	%cx, %ds
 	movw	%cx, %es

-- 
