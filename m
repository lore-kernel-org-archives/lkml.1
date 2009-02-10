Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZBJTKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZBJTKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZBJTDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:48 -0500
Received: from kroah.org ([198.145.64.141]:53806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755483AbZBJTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:44 -0500
Date: Tue, 10 Feb 2009 11:00:19 -0800
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
Subject: [patch 19/53] x86: APIC: enable workaround on AMD Fam10h CPUs
Message-ID: <20090210190019.GT14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-apic-enable-workaround-on-amd-fam10h-cpus.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
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
 arch/x86/kernel/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1451,7 +1451,7 @@ static int __init detect_init_APIC(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
-		    (boot_cpu_data.x86 == 15))
+		    (boot_cpu_data.x86 >= 15))
 			break;
 		goto no_apic;
 	case X86_VENDOR_INTEL:

