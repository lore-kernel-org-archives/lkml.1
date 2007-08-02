Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXHBQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXHBQ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbXHBQ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:26:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:25195 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXHBQ0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:26:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,213,1183359600"; 
   d="scan'208";a="275848208"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: scripts/mod/file2alias.c cross compile problem
Date: Thu, 2 Aug 2007 09:25:58 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0211AFF0@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1186067359.18821.553.camel@queen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scripts/mod/file2alias.c cross compile problem
Thread-Index: AcfVFx5VnwtdtCRlQoKYZhirhmSSbAACfnTA
From: "Luck, Tony" <tony.luck@intel.com>
To: <trenn@suse.de>, "Adrian Bunk" <bunk@stusta.de>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Jan Dittmer" <jdi@l4x.org>,
       "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 02 Aug 2007 16:26:00.0522 (UTC) FILETIME=[D01802A0:01C7D521]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Adrian Bunk: scripts/mod/file2alias.c is compiled with HOSTCC and ensures that
> kernel_ulong_t is correct, but it can't cope with different padding on
> different architectures.

Surely this is the root cause ... you can't expect that the alignment
rules of HOSTCC to make any sense for an arbitraty target.

> +#define FILLUP_LEN	7 /* dirty fix for i386 -> 64bit cross-compilation */
>  
>  struct acpi_device_id {
>  	__u8 id[ACPI_ID_LEN];
> +	__u8 dummy[FILLUP_LEN];
>  	kernel_ulong_t driver_data;
>  };

What's so special about this structure that we get an error?  Surely
there are many kernel structures with different alignment/padding
when built with i386 complier compared with ia64 compiler.  We can't
go around manually padding them all (it wastes time, and also wastes
memory on the 32-bit systems that don't need this padding).

-Tony
 
