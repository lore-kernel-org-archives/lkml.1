Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbZAOUsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbZAOUsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbZAOUCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:44 -0500
Received: from kroah.org ([198.145.64.141]:49661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763359AbZAOUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:38 -0500
Date: Thu, 15 Jan 2009 12:00:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 76/94] x86: fix RIP printout in early_idt_handler
Message-ID: <20090115200011.GX14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-rip-printout-in-early_idt_handler.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 7aed55d1085f71241284a30af0300feea48c36db upstream.

Impact: fix debug/crash printout

Since errorcode is popped out, RIP is on the top of the stack.
Use real RIP value instead of wrong CS.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -305,7 +305,7 @@ ENTRY(early_idt_handler)
 	call dump_stack
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
-	movq 8(%rsp),%rsi	# get rip again
+	movq 0(%rsp),%rsi	# get rip again
 	call __print_symbol
 #endif
 #endif /* EARLY_PRINTK */

