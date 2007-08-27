Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbXH0Rjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbXH0Rjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXH0Rjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:39:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:49423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbXH0Rji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:39:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,312,1183359600"; 
   d="scan'208";a="268565623"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] reverse CONFIG_ACPI_PROC_EVENT default
Date: Mon, 27 Aug 2007 13:39:34 -0400
Message-ID: <CFF307C98FEABE47A452B27C06B85BB603ABF93B@hdsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0708271602170.21853@blonde.wat.veritas.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] reverse CONFIG_ACPI_PROC_EVENT default
Thread-Index: Acfoy0miVwx3FRVrQyWprNmp8UNElQABesFw
References: <Pine.LNX.4.64.0708271602170.21853@blonde.wat.veritas.com>
From: "Brown, Len" <len.brown@intel.com>
To: "Hugh Dickins" <hugh@veritas.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Aug 2007 17:39:36.0638 (UTC) FILETIME=[3CA195E0:01C7E8D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Hugh.

-Len 

>-----Original Message-----
>From: Hugh Dickins [mailto:hugh@veritas.com] 
>Sent: Monday, August 27, 2007 11:05 AM
>To: Linus Torvalds
>Cc: Andrew Morton; Brown, Len; linux-kernel@vger.kernel.org
>Subject: [PATCH] reverse CONFIG_ACPI_PROC_EVENT default
>
>Sigh.  Again an ACPI assault on the Thinkpad's Fn+F4 to suspend to RAM.
>The default and text for CONFIG_THINKPAD_ACPI_INPUT_ENABLED were fixed
>in -rc3, but now 14e04fb34ffa82ee61ae69f98d8fca12d2e8e31c introduces
>CONFIG_ACPI_PROC_EVENT default n to disable it again.  Change default
>to y, and add comment to make it clearer that n is for future distros.
>
>Signed-off-by: Hugh Dickins <hugh@veritas.com>
>
>--- 2.6.23-rc3-git10/drivers/acpi/Kconfig	2007-08-26 
>18:10:15.000000000 +0100
>+++ linux/drivers/acpi/Kconfig	2007-08-26 18:59:16.000000000 +0100
>@@ -71,6 +71,7 @@ config ACPI_PROCFS
> config ACPI_PROC_EVENT
> 	bool "Deprecated /proc/acpi/event support"
> 	depends on PROC_FS
>+	default y
> 	---help---
> 	  A user-space daemon, acpi, typically read /proc/acpi/event
> 	  and handled all ACPI sub-system generated events.
>@@ -78,10 +79,13 @@ config ACPI_PROC_EVENT
> 	  These events are now delivered to user-space via
> 	  either the input layer, or as netlink events.
> 
>-	  This build option enables the old code for for legacy
>+	  This build option enables the old code for legacy
> 	  user-space implementation.  After some time, this will
> 	  be moved under CONFIG_ACPI_PROCFS, and then deleted.
> 
>+	  Say Y here to retain the old behaviour.  Say N if your
>+	  user-space is newer than kernel 2.6.23 (September 2007).
>+
> config ACPI_AC
> 	tristate "AC Adapter"
> 	depends on X86
>
