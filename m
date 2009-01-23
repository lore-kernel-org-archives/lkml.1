Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbZAWGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbZAWGVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbZAWGQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:34 -0500
Received: from kroah.org ([198.145.64.141]:36226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760892AbZAWGQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:33 -0500
Date: Thu, 22 Jan 2009 22:13:41 -0800
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
       alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>
Subject: [patch 14/40] IA64: Turn on CONFIG_HAVE_UNSTABLE_CLOCK
Message-ID: <20090123061341.GN2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ia64-turn-on-config_have_unstable_clock.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 0773a6cf673316440999752e23f8c3d4f85e48b9 upstream.

sched_clock() on ia64 is based on ar.itc, so is never
completely synchronized between cpus. On some platforms
(e.g. certain models of SGI Altix) it may be running at
radically different frequencies.

Based on a patch from Dimitri Sivanich which set this
just for SN2 && GENERIC kernels ... it is needed for
all ia64 machines.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES

