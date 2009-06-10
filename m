Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZFJDi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZFJDi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZFJDeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:25 -0400
Received: from kroah.org ([198.145.64.141]:56834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbZFJDeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:24 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:44 2009
Message-Id: <20090610002344.331335245@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:48 -0700
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
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/60] cpuidle: fix AMD C1E suspend hang
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=cpuidle-fix-amd-c1e-suspend-hang.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Shaohua Li <shaohua.li@intel.com>

commit 7d60e8ab0d5507229dfbdf456501cc378610fa01 upstream.

When AMD C1E is enabled, local APIC timer will stop even in C1. To avoid
suspend/resume hang, this patch removes C1 and replace it with a cpu_relax() in
suspend/resume path. This hasn't any impact in runtime path.

http://bugzilla.kernel.org/show_bug.cgi?id=13233

[ impact: avoid suspend/resume hang in AMD CPU with C1E enabled ]

Tested-by: Dmitry Lyzhyn <thisistempbox@yahoo.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1468,8 +1468,8 @@ static int acpi_idle_enter_c1(struct cpu
 
 	/* Do not access any ACPI IO ports in suspend path */
 	if (acpi_idle_suspend) {
-		acpi_safe_halt();
 		local_irq_enable();
+		cpu_relax();
 		return 0;
 	}
 


