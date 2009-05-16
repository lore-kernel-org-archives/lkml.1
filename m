Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZEPGu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZEPGu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 02:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZEPGuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 02:50:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:36510 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZEPGuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 02:50:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,203,1241420400"; 
   d="scan'208";a="143492924"
From: "Moore, Robert" <robert.moore@intel.com>
To: Len Brown <lenb@kernel.org>
CC: Bob Copeland <me@bobcopeland.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Fri, 15 May 2009 23:50:09 -0700
Subject: RE: [PATCH] ACPI: resume: re-enable SCI-enable workaround
Thread-Topic: [PATCH] ACPI: resume: re-enable SCI-enable workaround
Thread-Index: AcnV6hp2U7/k3/fMTgalHhJNYHJ/dAABlelQ
Message-ID: <4911F71203A09E4D9981D27F9D8308582DB91515@orsmsx503.amr.corp.intel.com>
References: <20090507105821.GA5864@hash.localnet>
 <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
 <1242192968.14626.40.camel@minggr.sh.intel.com>
 <200905131015.45635.rjw@sisk.pl>
 <b6c5339f0905130830k3549095dv3eee08d7d3155a37@mail.gmail.com>
 <alpine.LFD.2.00.0905152233180.4571@localhost.localdomain>
 <4911F71203A09E4D9981D27F9D8308582DB914DF@orsmsx503.amr.corp.intel.com>
 <alpine.LFD.2.00.0905160137210.4571@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905160137210.4571@localhost.localdomain>
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

ACPICA did not change the SCI_EN value. The #define associated with the control register has always been 0x0201 in ACPICA.

A linux patch changes the value from 0x0201 to 0x0200, and represents a divergence of linux from ACPICA.

What ACPICA did was to rename the #define, that is what broke the linux patch.


- #define ACPI_PM1_CONTROL_PRESERVED_BITS         0x0201  /* Bit 9, Bit 0 (SCI_EN) */


+ #define ACPI_PM1_CONTROL_IGNORED_BITS           0x0201  /* Bits 9, 0(SCI_EN) */
+ #define ACPI_PM1_CONTROL_RESERVED_BITS          0xC1F8  /* Bits 14-15, 3-8 */
+#define ACPI_PM1_CONTROL_PRESERVED_BITS \
+         (ACPI_PM1_CONTROL_IGNORED_BITS | ACPI_PM1_CONTROL_RESERVED_BITS)




>-----Original Message-----
>From: Len Brown [mailto:lenb@kernel.org]
>Sent: Friday, May 15, 2009 10:50 PM
>To: Moore, Robert
>Cc: Bob Copeland; Rafael J. Wysocki; Lin, Ming M; Bjorn Helgaas; Zhao,
>Yakui; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org
>Subject: RE: [PATCH] ACPI: resume: re-enable SCI-enable workaround
>
>
>> >The BIOS bug workaround mistakenly got disabled
>> >when we followed the ACPI specification more closely
>> >by ignoring OS updates to that bit.
>>
>> Not exactly. ACPICA has always preserved the SCI_EN bit. Linux apparently
>has a "linux-only" patch to ACPICA that disables this.
>>
>> The recent version of ACPICA change the #define enough such that the
>patch no longer works.
>
>"We" here means Linux, and thus the description is accurate.
>
>The fact is that in 2.6.29 Linux had
>ACPI_PM1_CONTROL_PRESERVED_BITS 0x0200
>and when "we" updated it to 0x201 via the ACPICA update,
>the workaround in the Linux resume code became a NOP.
>
>-Len
