Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYCVAHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYCVAHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 20:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYCVAHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 20:07:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:28490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYCVAHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 20:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,537,1199692800"; 
   d="scan'208";a="221560504"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH, RFC] Create 'slot' sysfs attributein/sys/devices/system/cpu/cpuN/topology/
Date: Fri, 21 Mar 2008 16:58:30 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE13C6E@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080319233140.GD16237@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH, RFC] Create 'slot' sysfs attributein/sys/devices/system/cpu/cpuN/topology/
Thread-Index: AciKGWkWI+JsGF1mSza4u/9FKmYOyQBlP1BQ
References: <20080310222735.GA22619@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECCBFA9D@orsmsx424.amr.corp.intel.com> <20080319233140.GD16237@ldl.fc.hp.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Alex Chiang" <achiang@hp.com>
Cc: <lenb@kernel.org>, <linux-ia64@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Mar 2008 23:58:31.0974 (UTC) FILETIME=[7774CC60:01C88BAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	if (ACPI_SUCCESS(acpi_get_handle(pr->handle, "_SUN", &handle))) {
+		status = acpi_evaluate_object(pr->handle,
+						"_SUN", NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			object.integer.value = -1;
+	} else {
+		object.integer.value = -1;
+	}
+	arch_set_topology_slot(pr->id, object.integer.value);
+
 	if (!object.processor.pblk_address)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
 	else if (object.processor.pblk_length != 6)

I'm still seeing these messages:

 "ACPI: Invalid PBLK length [0]"

for every cpu.  Presumably because "object" is a union and when
you did the "object.integer.value = -1;" you scribbled on some bits
that were needed in the subsequent code.

-Tony
