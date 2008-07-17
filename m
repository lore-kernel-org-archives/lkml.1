Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYGQRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYGQRUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYGQRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:20:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:44533 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYGQRUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,204,1215414000"; 
   d="scan'208";a="21641359"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
Date: Thu, 17 Jul 2008 10:20:07 -0700
Message-ID: <9D39833986E69849A2A8E74C1078B6B3ADFA66@orsmsx415.amr.corp.intel.com>
In-reply-to: <487F81A6.76E4.0078.0@novell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
Thread-Index: AcjoIfa5y7O/whIyQMCtj69+k1RLAwADueng
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com> <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com> <487F2629.76E4.0078.0@novell.com> <487F0B85.4030202@linux.intel.com> <487F29B2.76E4.0078.0@novell.com> <487F3AFA.7090908@linux.intel.com> <76366b180807170603qaf669a5q625fc166a2045756@mail.gmail.com> <487F6C32.76E4.0078.0@novell.com> <76366b180807170732i112d54bcl49f630a3064f87f@mail.gmail.com> <487F81A6.76E4.0078.0@novell.com>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Jan Beulich" <jbeulich@novell.com>,
       "Andrew Paprocki" <andrew@ishiboo.com>
Cc: "Len Brown" <lenb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@linux.intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Jul 2008 17:20:08.0369 (UTC) FILETIME=[5C8AA210:01C8E831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, in the number of the cases like this that I've seen, it's the v2
fields that have problems. Perhaps the heuristic should be something
like "if there is an inconsistency between the v1 and v2 fields, fall
back to v1". 

Bob


>-----Original Message-----
>From: Jan Beulich [mailto:jbeulich@novell.com]
>Sent: Thursday, July 17, 2008 8:30 AM
>To: Andrew Paprocki
>Cc: Moore, Robert; Len Brown; Andrew Morton; Andi Kleen; LKML
>Subject: Re: ACPI WARNING: at
>drivers/acpi/tables/tbfadt.c:348acpi_tb_create_local_fadt+0x147/0x2f4()
>
>>>> "Andrew Paprocki" <andrew@ishiboo.com> 17.07.08 16:32 >>>
>>On Thu, Jul 17, 2008 at 9:58 AM, Jan Beulich <jbeulich@novell.com>
wrote:
>>>>>> "Andrew Paprocki" <andrew@ishiboo.com> 17.07.08 15:03 >>>
>>>>On Thu, Jul 17, 2008 at 8:28 AM, Andi Kleen <ak@linux.intel.com>
wrote:
>>>>> Ok, but we can just get that from a table dump.
>>>>
>>>>Output from acpidump is attached.
>>>
>>> Just as I suspected - the v1 field says 4 bytes, but the v2 field
says 8
>bits.
>>
>>So does the BIOS owner need to fix the table? If you could give me the
>>exact text to pass along to the mobo mfr, I will forward it and I can
>>get them to release a new BIOS rev.
>
>I'm not sure how else to express what I already said above: They simply
>need to get (in ACPI spec terms) the FADT's X_PM1a_EVT_BLK in sync
>with PM1_EVT_LEN (and they should at once make sure other
>X_PM*_BLK and X_GPE?_BLK fields are in sync with their respective
>legacy fields, too - while looking at the dump, it seemed there were
more
>inconsistencies).
>
>Jan

