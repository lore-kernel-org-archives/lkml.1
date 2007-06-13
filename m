Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXFMBiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXFMBiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXFMBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:37:59 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61836 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbXFMBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:37:57 -0400
Subject: RE: v2.6.21.4-rt11
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F50101D9F6@scsmsx415.amr.corp.intel.com>
References: <653FFBB4508B9042B5D43DC9E18836F50101D9F6@scsmsx415.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 21:37:55 -0400
Message-Id: <1181698675.6220.10.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-06 at 06:00 -0700, Pallipadi, Venkatesh wrote:
> 
> >-----Original Message-----

> Yes. Force_hpet part is should have worked..
> Eric: Can you send me the output of 'lspci -n on your system.
> We need to double check we are covering all ICH7 ids.

Here it is:

00:00.0 0600: 8086:2770 (rev 02)
00:02.0 0300: 8086:2772 (rev 02)
00:1b.0 0403: 8086:27d8 (rev 01)
00:1c.0 0604: 8086:27d0 (rev 01)
00:1c.1 0604: 8086:27d2 (rev 01)
00:1d.0 0c03: 8086:27c8 (rev 01)
00:1d.1 0c03: 8086:27c9 (rev 01)
00:1d.2 0c03: 8086:27ca (rev 01)
00:1d.3 0c03: 8086:27cb (rev 01)
00:1d.7 0c03: 8086:27cc (rev 01)
00:1e.0 0604: 8086:244e (rev e1)
00:1f.0 0601: 8086:27b8 (rev 01)
00:1f.1 0101: 8086:27df (rev 01)
00:1f.2 0101: 8086:27c0 (rev 01)
00:1f.3 0c05: 8086:27da (rev 01)
01:0a.0 0604: 3388:0021 (rev 11)
02:0c.0 0c03: 1033:0035 (rev 41)
02:0c.1 0c03: 1033:0035 (rev 41)
02:0c.2 0c03: 1033:00e0 (rev 02)
02:0d.0 0c00: 1106:3044 (rev 46)
03:00.0 0200: 8086:109a

Adding the id for PCI_DEVICE_ID_INTEL_ICH7_0 (27b8) should do the trick.

I've patched my kernel and was ready to test it, but in the meantime I
did a BIOS upgrade (bad idea...) and with the new version the HPET timer
is detected via ACPI.

Unfortunately it seems that downgrading the BIOS is a lot more trouble
than upgrading it. So I cannot easily test the force enable anymore.

Anyway it works now. Here is my patch if it's any use to you:


diff -uprN linux-2.6.21.4.orig/arch/i386/kernel/quirks.c linux-2.6.21.4/arch/i386/kernel/quirks.c
--- linux-2.6.21.4.orig/arch/i386/kernel/quirks.c	Tue Jun 12 10:03:18 2007
+++ linux-2.6.21.4/arch/i386/kernel/quirks.c	Tue Jun 12 10:08:02 2007
@@ -149,6 +149,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
                          ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
+                         ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,


Best regards,

- Eric


