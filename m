Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbZIEAW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbZIEAW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964836AbZIEAVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:38 -0400
Received: from kroah.org ([198.145.64.141]:42205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934641AbZIEAVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:54 2009
Message-Id: <20090905001454.744161385@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 48/71] x86, amd: Dont probe for extended APIC ID if APICs are disabled
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=x86-amd-don-t-probe-for-extended-apic-id-if-apics-are-disabled.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 2cb078603abb612e3bcd428fb8122c3d39e08832 upstream.

If we've logically disabled apics, don't probe the PCI space for the
AMD extended APIC ID.

[ Impact: prevent boot crash under Xen. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reported-by: Bastian Blank <bastian@waldi.eu.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -356,7 +356,7 @@ static void __cpuinit early_init_amd(str
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
 	/* check CPU config space for extended APIC ID */
-	if (c->x86 >= 0xf) {
+	if (cpu_has_apic && c->x86 >= 0xf) {
 		unsigned int val;
 		val = read_pci_config(0, 24, 0, 0x68);
 		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))


