Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZESO2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZESO2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZESO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:28:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:2758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZESO2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:28:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,215,1241420400"; 
   d="scan'208";a="691735376"
From: "Moore, Robert" <robert.moore@intel.com>
To: Alex Chiang <achiang@hp.com>, "lenb@kernel.org" <lenb@kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 May 2009 07:28:40 -0700
Subject: RE: [PATCH] ACPICA: Eliminate double call to
 acpi_ns_get_parent_node in	acpi_get_parent
Thread-Topic: [PATCH] ACPICA: Eliminate double call to
 acpi_ns_get_parent_node in	acpi_get_parent
Thread-Index: AcnYMSxUE2vaEQtQTK6CGzZfBIfFFQAXOAOA
Message-ID: <4911F71203A09E4D9981D27F9D8308582E01977B@orsmsx503.amr.corp.intel.com>
References: <20090519032244.3729.46729.stgit@bob.kio>
In-Reply-To: <20090519032244.3729.46729.stgit@bob.kio>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will integrate this into ACPICA.

Thanks,
Bob


>-----Original Message-----
>From: Alex Chiang [mailto:achiang@hp.com]
>Sent: Monday, May 18, 2009 8:23 PM
>To: lenb@kernel.org
>Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; Moore, Robert
>Subject: [PATCH] ACPICA: Eliminate double call to acpi_ns_get_parent_node
>in acpi_get_parent
>
>Cache the value of the parent node so we don't have to look it up twice.
>
>Cc: Robert Moore <robert.moore@intel.com>
>Signed-off-by: Alex Chiang <achiang@hp.com>
>---
>
> drivers/acpi/acpica/nsxfobj.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/acpi/acpica/nsxfobj.c b/drivers/acpi/acpica/nsxfobj.c
>index 1c7efc1..1cd8f15 100644
>--- a/drivers/acpi/acpica/nsxfobj.c
>+++ b/drivers/acpi/acpica/nsxfobj.c
>@@ -161,7 +161,7 @@ ACPI_EXPORT_SYMBOL(acpi_get_type)
>
>***************************************************************************
>***/
> acpi_status acpi_get_parent(acpi_handle handle, acpi_handle * ret_handle)
> {
>-	struct acpi_namespace_node *node;
>+	struct acpi_namespace_node *node, *parent_node;
> 	acpi_status status;
>
> 	if (!ret_handle) {
>@@ -189,12 +189,12 @@ acpi_status acpi_get_parent(acpi_handle handle,
>acpi_handle * ret_handle)
>
> 	/* Get the parent entry */
>
>-	*ret_handle =
>-	    acpi_ns_convert_entry_to_handle(acpi_ns_get_parent_node(node));
>+	parent_node = acpi_ns_get_parent_node(node);
>+	*ret_handle = acpi_ns_convert_entry_to_handle(parent_node);
>
> 	/* Return exception if parent is null */
>
>-	if (!acpi_ns_get_parent_node(node)) {
>+	if (!parent_node) {
> 		status = AE_NULL_ENTRY;
> 	}
>

