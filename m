Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbXAZXWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbXAZXWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 18:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXAZXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 18:22:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:12074 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbXAZXWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 18:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,244,1167638400"; 
   d="scan'208"; a="173497405:sNHT24428831"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] -  increase acpi owner_id max
Date: Fri, 26 Jan 2007 15:21:30 -0800
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A401C68471@orsmsx415.amr.corp.intel.com>
In-Reply-To: <20070126224004.21202.43805.sendpatchset@attica.americas.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] -  increase acpi owner_id max
Thread-Index: AcdBm4H7FqDpCSP9T/qiZfOSjgQDrgABLWpQ
From: "Moore, Robert" <robert.moore@intel.com>
To: "John Keller" <jpk@sgi.com>, <linux-acpi@vger.kernel.org>
Cc: <ayoung@sgi.com>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 26 Jan 2007 23:22:04.0997 (UTC) FILETIME=[CA6B9750:01C741A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The OwnerId field within a namespace node is 8 bits, and this is the
main constraint on the maximum OwnerId. You can't simply bump up the
number of owner ids without changing this field.

If we need more than 255 owner Ids, the width of this field will have to
be increased, or we will need to use a pointer for the field in order to
maintain a linked list of all nodes owned by a particular owner.

Bob

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of John Keller
> Sent: Friday, January 26, 2007 2:40 PM
> To: linux-acpi@vger.kernel.org
> Cc: ayoung@sgi.com; linux-ia64@vger.kernel.org; linux-
> kernel@vger.kernel.org; John Keller
> Subject: [PATCH 1/1] - increase acpi owner_id max
> 
> To support systems with large IO configurations,
> this patch increases the number of available ACPI
> owner ids to 1023.
> 
> On SN platforms, we represent every populated root
> bus slot with an ACPI SSDT table containing info
> for every device and PPB attached to the slot.
> Each SSDT requires a unique ACPI owner id.
> 
> Signed-off-by: John Keller <jpk@sgi.com>
> ---
> 
>  drivers/acpi/utilities/utmisc.c |    6 +++---
>  include/acpi/acconfig.h         |    4 ++--
>  include/acpi/aclocal.h          |    4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> 
> Index: linux/drivers/acpi/utilities/utmisc.c
> ===================================================================
> --- linux.orig/drivers/acpi/utilities/utmisc.c	2007-01-25
> 11:27:25.509259412 -0600
> +++ linux/drivers/acpi/utilities/utmisc.c	2007-01-26
13:16:09.551081284 -
> 0600
> @@ -147,7 +147,7 @@ acpi_status acpi_ut_allocate_owner_id(ac
>  				/*
>  				 * Construct encoded ID from the index
and bit
> position
>  				 *
> -				 * Note: Last [j].k (bit 255) is never
used and is
> marked
> +				 * Note: Last [j].k (bit 1023) is never
used and
> is marked
>  				 * permanently allocated (prevents +1
overflow)
>  				 */
>  				*owner_id =
> @@ -175,7 +175,7 @@ acpi_status acpi_ut_allocate_owner_id(ac
>  	 */
>  	status = AE_OWNER_ID_LIMIT;
>  	ACPI_ERROR((AE_INFO,
> -		    "Could not allocate new OwnerId (255 max),
> AE_OWNER_ID_LIMIT"));
> +		    "Could not allocate new OwnerId (1023 max),
> AE_OWNER_ID_LIMIT"));
> 
>        exit:
>  	(void)acpi_ut_release_mutex(ACPI_MTX_CACHES);
> @@ -192,7 +192,7 @@ acpi_status acpi_ut_allocate_owner_id(ac
>   *              control method or unloading a table. Either way, we
would
>   *              ignore any error anyway.
>   *
> - * DESCRIPTION: Release a table or method owner ID.  Valid IDs are 1
-
> 255
> + * DESCRIPTION: Release a table or method owner ID.  Valid IDs are 1
-
> 1023
>   *
> 
>
************************************************************************
**
> ****/
> 
> Index: linux/include/acpi/acconfig.h
> ===================================================================
> --- linux.orig/include/acpi/acconfig.h	2007-01-25
11:27:25.577267818 -
> 0600
> +++ linux/include/acpi/acconfig.h	2007-01-26 13:17:14.111002597
-0600
> @@ -111,9 +111,9 @@
> 
>  #define ACPI_SYSMEM_REGION_WINDOW_SIZE  4096
> 
> -/* owner_id tracking. 8 entries allows for 255 owner_ids */
> +/* owner_id tracking. 32 entries allow for 1023 owner_ids */
> 
> -#define ACPI_NUM_OWNERID_MASKS          8
> +#define ACPI_NUM_OWNERID_MASKS		32
> 
> 
>
/***********************************************************************
**
> *****
>   *
> Index: linux/include/acpi/aclocal.h
> ===================================================================
> --- linux.orig/include/acpi/aclocal.h	2007-01-25 11:27:25.585268807 -
> 0600
> +++ linux/include/acpi/aclocal.h	2007-01-26 13:20:06.148115848
-0600
> @@ -122,8 +122,8 @@ static char *acpi_gbl_mutex_names[ACPI_N
> 
>  /* Owner IDs are used to track namespace nodes for selective deletion
*/
> 
> -typedef u8 acpi_owner_id;
> -#define ACPI_OWNER_ID_MAX               0xFF
> +typedef u16 acpi_owner_id;
> +#define ACPI_OWNER_ID_MAX               0x3FF
> 
>  /* This Thread ID means that the mutex is not in use (unlocked) */
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
