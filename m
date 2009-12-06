Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbZLFCP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbZLFCP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZLFCP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:15:56 -0500
Received: from mout7.freenet.de ([195.4.92.97]:55033 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbZLFCP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:15:56 -0500
Message-ID: <4B1B1336.5020309@freenet.de>
Date: Sun, 06 Dec 2009 03:13:10 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan@redhat.com
Subject: [PATCH]: drivers/platform/x86/Kconfig - fix inconsistency
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just discovered an inconsistency in a Kconfig file. DELL_WMI as well 
as HP_WMI should not depend on ACPI_WMI but select it, as all the other 
WMI-related,  platform-specific device drivers like TC1100_WMI or 
ACER_WMI do.

This -as of right now- prevents the selection of the two initially 
mentioned drivers unless one, by chance, enables ACPI_WMI and then goes 
back.


Signed-off-by: Patrick Ringl <patrick_@freenet.de>

--- linux-2.6.32-o/drivers/platform/x86/Kconfig    2009-12-03 
04:51:21.000000000 +0100
+++ linux-2.6.32/drivers/platform/x86/Kconfig    2009-12-06 
02:32:47.000000000 +0100
@@ -86,8 +86,8 @@
 
 config DELL_WMI
     tristate "Dell WMI extras"
-    depends on ACPI_WMI
     depends on INPUT
+    select ACPI_WMI
     ---help---
       Say Y here if you want to support WMI-based hotkeys on Dell laptops.
 
@@ -133,9 +133,9 @@
 
 config HP_WMI
     tristate "HP WMI extras"
-    depends on ACPI_WMI
     depends on INPUT
     depends on RFKILL || RFKILL = n
+    select ACPI_WMI
     help
      Say Y here if you want to support WMI-based hotkeys on HP laptops and
      to read data from WMI such as docking or ambient light sensor state.
---



regards,
Patrick
