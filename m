Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbZBDS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbZBDS72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbZBDSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:30 -0500
Received: from kroah.org ([198.145.64.141]:32771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759329AbZBDStV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:21 -0500
Date: Wed, 4 Feb 2009 10:46:30 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 21/41] cpuidle: upon BIOS bug, default to default_idle
	rather than polling
Message-ID: <20090204184630.GV25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpuidle-upon-bios-bug-default-to-default_idle-rather-than-polling.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 89cedfefca1d446ee2598fd3bcbb23ee3802e26a upstream

http://bugzilla.kernel.org/show_bug.cgi?id=11345

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig          |    3 +++
 drivers/cpuidle/cpuidle.c |    4 ++++
 2 files changed, 7 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,9 @@ config GENERIC_TIME_VSYSCALL
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
+config ARCH_HAS_DEFAULT_IDLE
+	def_bool y
+
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -56,7 +56,11 @@ static void cpuidle_idle_call(void)
 		if (pm_idle_old)
 			pm_idle_old();
 		else
+#if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
+			default_idle();
+#else
 			local_irq_enable();
+#endif
 		return;
 	}
 

