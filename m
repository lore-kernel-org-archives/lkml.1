Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYBWAdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYBWAdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbYBWAdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:55200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759651AbYBWAdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:05 -0500
Date: Fri, 22 Feb 2008 16:29:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sam Ravnborg <sam@ravnborg.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/38] SPARC/SPARC64: Fix usage of .section .sched.text in
	assembler code.
Message-ID: <20080223002928.GB7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-sparc64-fix-usage-of-.section-.sched.text-in-assembler-code.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 
 [SPARC/SPARC64]: Fix usage of .section .sched.text in assembler code.

Upstream commit: c6d64c16bb193c8ca2ccc0b3c556a4574a02408b

ld will generate an unique named section when assembler do not use
"ax" but gcc does. Add the missing annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/lib/rwsem.S   |    2 +-
 arch/sparc64/lib/rwsem.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/lib/rwsem.S
+++ b/arch/sparc/lib/rwsem.S
@@ -7,7 +7,7 @@
 #include <asm/ptrace.h>
 #include <asm/psr.h>
 
-	.section .sched.text
+	.section .sched.text, "ax"
 	.align	4
 
 	.globl		___down_read
--- a/arch/sparc64/lib/rwsem.S
+++ b/arch/sparc64/lib/rwsem.S
@@ -6,7 +6,7 @@
 
 #include <asm/rwsem-const.h>
 
-	.section	.sched.text
+	.section	.sched.text, "ax"
 
 	.globl		__down_read
 __down_read:

-- 
