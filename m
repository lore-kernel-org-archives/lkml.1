Return-Path: <linux-kernel-owner+w=401wt.eu-S1762850AbYGaANk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850AbYGaANk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYGaAMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:12:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762693AbYGaAMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:12:36 -0400
Date: Wed, 30 Jul 2008 16:58:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jan Kratochvil <jan.kratochvil@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 25/62] x86: fix crash due to missing debugctlmsr on AMD K6-3
Message-ID: <20080730235841.GX12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-crash-due-to-missing-debugctlmsr-on-amd-k6-3.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Jan Kratochvil <jan.kratochvil@redhat.com>

commit d536b1f86591fb081c7a56eab04e711eb4dab951 upstream

currently if you use PTRACE_SINGLEBLOCK on AMD K6-3 (i586) it will crash.
Kernel now wrongly assumes existing DEBUGCTLMSR MSR register there.

Removed the assumption also for some other non-K6 CPUs but I am not sure there
(but it can only bring small inefficiency there if my assumption is wrong).

Based on info from Roland McGrath, Chuck Ebbert and Mikulas Patocka.
More info at:
	https://bugzilla.redhat.com/show_bug.cgi?id=456175

Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -414,4 +414,4 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)

-- 
