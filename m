Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZBKAdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZBKAdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZBKA2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:20 -0500
Received: from kroah.org ([198.145.64.141]:51106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757522AbZBKA2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:17 -0500
Date: Tue, 10 Feb 2009 16:24:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 16/56] x86: APIC: enable workaround on AMD Fam10h CPUs
Message-ID: <20090211002447.GQ14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-apic-enable-workaround-on-amd-fam10h-cpus.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 858770619debfb9269add63e4ba8b7c6b5538dd1 upstream.

Impact: fix to enable APIC for AMD Fam10h on chipsets with a missing/b0rked
	ACPI MP table (MADT)

Booting a 32bit kernel on an AMD Fam10h CPU running on chipsets with
missing/b0rked MP table leads to a hang pretty early in the boot process
due to the APIC not being initialized. Fix that by falling back to the
default APIC base address in 32bit code, as it is done in the 64bit
codepath.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1115,7 +1115,7 @@ static int __init detect_init_APIC(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
-		    (boot_cpu_data.x86 == 15))
+		    (boot_cpu_data.x86 >= 15))
 			break;
 		goto no_apic;
 	case X86_VENDOR_INTEL:

