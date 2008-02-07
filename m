Return-Path: <linux-kernel-owner+w=401wt.eu-S934317AbYBGVEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbYBGVEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbYBGUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:38614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933311AbYBGUwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:32 -0500
Date: Thu, 7 Feb 2008 12:47:44 -0800
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
       Sam Ravnborg <sam@ravnborg.org>, "Cc: Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "A.E.Lawrence" <lawrence_a_e@ntlworld.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 28/45] x86: restore correct module name for apm
Message-ID: <20080207204744.GC16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-restore-correct-module-name-for-apm.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sam Ravnborg <sam@ravnborg.org>

patch 3a900d89db35c133bc0874e71d9156b22db362b4 in mainline

The apm module were renamed to apm_32 during the merge of 32 and 64 bit
x86 which is unfortunate. As apm is 32 bit specific we like to keep the
_32 in the filename but the module should be named apm.

Fix this in the Makefile.

Reported-by: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/Makefile_32 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -19,7 +19,8 @@ obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
-obj-$(CONFIG_APM)		+= apm_32.o
+apm-y				:= apm_32.o
+obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= smpcommon_32.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o

-- 
