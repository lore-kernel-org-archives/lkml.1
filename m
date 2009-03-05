Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZCEAMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZCEAMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 19:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZCEAMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 19:12:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:56445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZCEAM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 19:12:29 -0500
Message-ID: <49AF18B7.4050305@kernel.org>
Date: Wed, 04 Mar 2009 16:11:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/doc: doc the using earlyprintk=dbgp
References: <m1bpshx912.fsf@fess.ebiederm.org> <Pine.LNX.4.44L0.0903041657140.6145-100000@iolanthe.rowland.org> <20090304225500.GB13509@gamba.jf.intel.com>
In-Reply-To: <20090304225500.GB13509@gamba.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: doc

simple using howto for earlyprintk=dbgp

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/x86/earlyprintk.txt |   41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: linux-2.6/Documentation/x86/earlyprintk.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/x86/earlyprintk.txt
@@ -0,0 +1,41 @@
+
+Using earlyprintk with USB2 Debug port and debug cable
+
+1. HW:
+a. target system need to have debug port
+
+# lspci -vvv
+...
+00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
+        Subsystem: Lenovo ThinkPad T61
+        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
+        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
+        Latency: 0
+        Interrupt: pin D routed to IRQ 19
+        Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
+        Capabilities: [50] Power Management version 2
+                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
+                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
+        Capabilities: [58] Debug port: BAR=1 offset=00a0
+        Kernel driver in use: ehci_hcd
+        Kernel modules: ehci-hcd
+...
+b. netchip USB debug cable
+   http://www.plxtech.com/products/NET2000/NET20DC/default.asp
+
+c. console system: have USB2 port
+
+2. SW setting
+a. console system: need to have kernel config
+   CONFIG_USB_SERIAL_DEBUG
+   you should get /dev/ttyUSBx
+
+   # cat /dev/ttyUSBx could get output
+
+b. target system: need to have kernel config
+   CONFIG_EARLY_PRINTK_DBGP
+
+   boot command line: earlyprintk=dbgp
+
+c. for Nvidia Southbridge based system: kernel will try to probe and find out which port has debug device connneted.
+
