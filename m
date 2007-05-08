Return-Path: <linux-kernel-owner+w=401wt.eu-S967413AbXEHMHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967413AbXEHMHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967434AbXEHMHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:07:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47040 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967405AbXEHMHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:07:11 -0400
Date: Tue, 08 May 2007 21:06:18 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] Fix unnecesary meminit
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20070506175326.GA9855@uranus.ravnborg.org>
References: <20070504170421.b1ab2d16.akpm@linux-foundation.org> <20070506175326.GA9855@uranus.ravnborg.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070508210318.10DA.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It doesn't make a lot of sense to export an __init symbol to modules.  I
> > guess it's OK in this case, but we get warnings:
> 
> It seems wrong to me to first tell linker to discard the code after init and
> next to export the symbol to make it available for any module anytime.
> 
> Both function are relatively small so better avoid playing games and
> drop the __meminit tag.

Ok. This is the patch.


-------
This is to fix unnecessary __meminit definition.
These are exported for kernel modules.

I compiled on ia64/x86-64 with memory hotplug on/off.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

 drivers/acpi/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm1/drivers/acpi/numa.c
===================================================================
--- linux-2.6.21-mm1.orig/drivers/acpi/numa.c	2007-05-08 19:33:05.000000000 +0900
+++ linux-2.6.21-mm1/drivers/acpi/numa.c	2007-05-08 19:33:12.000000000 +0900
@@ -228,7 +228,7 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
-int __meminit acpi_get_pxm(acpi_handle h)
+int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long pxm;
 	acpi_status status;
@@ -246,7 +246,7 @@ int __meminit acpi_get_pxm(acpi_handle h
 }
 EXPORT_SYMBOL(acpi_get_pxm);
 
-int __meminit acpi_get_node(acpi_handle *handle)
+int acpi_get_node(acpi_handle *handle)
 {
 	int pxm, node = -1;
 

-- 
Yasunori Goto 


