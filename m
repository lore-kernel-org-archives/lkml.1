Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbXKTSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbXKTSg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbXKTS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:28:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761309AbXKTS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:05 -0500
Date: Tue, 20 Nov 2007 10:24:50 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrey Mirkin <major@openvz.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 22/29] x86: return correct error code from child_rip in
	x86_64 entry.S
Message-ID: <20071120182450.GX28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x98-return-correct-error-code-from-child-rip.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrey Mirkin <major@openvz.org>

patch 1c5b5cfd290b6cb7c67020ef420e275f746a7236 in mainline.

x86: return correct error code from child_rip in x86_64 entry.S

Right now register edi is just cleared before calling do_exit.
That is wrong because correct return value will be ignored.
Value from rax should be copied to rdi instead of clearing edi.

AK: changed to 32bit move because it's strictly an int

[ tglx: arch/x86 adaptation ]

Signed-off-by: Andrey Mirkin <major@openvz.org>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -989,7 +989,7 @@ child_rip:
 	movq %rsi, %rdi
 	call *%rax
 	# exit
-	xorl %edi, %edi
+	mov %eax, %edi
 	call do_exit
 	CFI_ENDPROC
 ENDPROC(child_rip)

-- 
