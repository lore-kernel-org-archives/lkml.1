Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbYGRQwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbYGRQwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbYGRQwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:52:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:29393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbYGRQwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:52:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,211,1215414000"; 
   d="scan'208";a="316493481"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ACPI WARNING: atdrivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
Date: Fri, 18 Jul 2008 09:52:36 -0700
Message-ID: <9D39833986E69849A2A8E74C1078B6B3AE0132@orsmsx415.amr.corp.intel.com>
In-reply-to: <488073B8.76E4.0078.0@novell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ACPI WARNING: atdrivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
Thread-Index: Acjosj5DwbI9RrrkRkGYIBm4CuU4dwARBbuQ
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com> <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com> <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com> <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com> <487F6C32.76E4.0078.0@novell.com> <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com> <487F81A6.76E4.0078.0@novell.com> <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com> <488073B8.76E4.0078.0@novell.com>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Jan Beulich" <jbeulich@novell.com>, "Andi Kleen" <ak@linux.intel.com>
Cc: "Andrew Paprocki" <andrew@ishiboo.com>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2008 16:52:36.0597 (UTC) FILETIME=[AE6BFA50:01C8E8F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>shouldn't the v2 ones be sanity-checked
>against the v1 ones and then the specified widths be used as intended
>by the spec?

We are still investigating this. Suffice to say that we have not
encountered any hardware that actually uses different values. One of our
BIOS guys is going to determine what windows does with the bit_width
fields. At the same time, we will go ahead and figure out how it handles
the case when the v1 and v2(X) fields are in conflict.


>-----Original Message-----
>From: Jan Beulich [mailto:jbeulich@novell.com]
>Sent: Friday, July 18, 2008 1:43 AM
>To: Moore, Robert; Andi Kleen
>Cc: Andrew Paprocki; Len Brown; Andrew Morton; LKML
>Subject: RE: ACPI WARNING:
>atdrivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4
()
>
>>>> "Moore, Robert" <robert.moore@intel.com> 17.07.08 19:20 >>>
>>So far, in the number of the cases like this that I've seen, it's the
v2
>>fields that have problems. Perhaps the heuristic should be something
>>like "if there is an inconsistency between the v1 and v2 fields, fall
>>back to v1".
>
>While extending the patch to do so, I realize that other v2 fields are
>used as-is, no matter whether their bit_width (or other fields) are
>wrong. Is that perhaps why hardware/hwregs.c uses hard-coded
>constants rather than the specified widths? If so (and if the v1 fields
>are considered reliable), shouldn't the v2 ones be sanity-checked
>against the v1 ones and then the specified widths be used as intended
>by the spec?
>
>Jan

