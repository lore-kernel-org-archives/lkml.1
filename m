Return-Path: <linux-kernel-owner+w=401wt.eu-S965477AbXBFWLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477AbXBFWLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXBFWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:11:42 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39697 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965477AbXBFWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:11:41 -0500
Date: Tue, 6 Feb 2007 23:11:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] #ifdef ACPI_FUTURE_USAGE acpi_os_readable()
Message-ID: <20070206221145.GF27397@stusta.de>
References: <20070129204528.eb8d695e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm2:
>...
>  git-acpi.patch
>...
>  git trees
>...


acpi_os_readable() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/acpi/osl.c      |    2 --
 include/acpi/acpiosxf.h |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm3/include/acpi/acpiosxf.h.old	2007-02-06 06:57:15.000000000 +0100
+++ linux-2.6.20-rc6-mm3/include/acpi/acpiosxf.h	2007-02-06 06:57:53.000000000 +0100
@@ -240,9 +240,8 @@
 acpi_os_validate_address(u8 space_id,
 			 acpi_physical_address address, acpi_size length);
 
-u8 acpi_os_readable(void *pointer, acpi_size length);
-
 #ifdef ACPI_FUTURE_USAGE
+u8 acpi_os_readable(void *pointer, acpi_size length);
 u8 acpi_os_writable(void *pointer, acpi_size length);
 #endif
 
--- linux-2.6.20-rc6-mm3/drivers/acpi/osl.c.old	2007-02-06 07:18:33.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/acpi/osl.c	2007-02-06 07:18:54.000000000 +0100
@@ -888,7 +888,6 @@
 
 	return 0;
 }
-#endif				/*  ACPI_FUTURE_USAGE  */
 
 /* Assumes no unreadable holes inbetween */
 u8 acpi_os_readable(void *ptr, acpi_size len)
@@ -901,7 +900,6 @@
 	return 1;
 }
 
-#ifdef ACPI_FUTURE_USAGE
 u8 acpi_os_writable(void *ptr, acpi_size len)
 {
 	/* could do dummy write (racy) or a kernel page table lookup.

