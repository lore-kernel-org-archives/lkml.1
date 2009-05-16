Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZEPDaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZEPDaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 23:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZEPDam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 23:30:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:1274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZEPDal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 23:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,202,1241420400"; 
   d="scan'208";a="516030446"
From: "Moore, Robert" <robert.moore@intel.com>
To: Len Brown <lenb@kernel.org>, Bob Copeland <me@bobcopeland.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "Lin, Ming M" <ming.m.lin@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Fri, 15 May 2009 20:30:41 -0700
Subject: RE: [PATCH] ACPI: resume: re-enable SCI-enable workaround
Thread-Topic: [PATCH] ACPI: resume: re-enable SCI-enable workaround
Thread-Index: AcnVztRWV2M7ytrfThyv+1YrTFE8lwAB5j3Q
Message-ID: <4911F71203A09E4D9981D27F9D8308582DB914DF@orsmsx503.amr.corp.intel.com>
References: <20090507105821.GA5864@hash.localnet>
 <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
 <1242192968.14626.40.camel@minggr.sh.intel.com>
 <200905131015.45635.rjw@sisk.pl>
 <b6c5339f0905130830k3549095dv3eee08d7d3155a37@mail.gmail.com>
 <alpine.LFD.2.00.0905152233180.4571@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905152233180.4571@localhost.localdomain>
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


>The BIOS bug workaround mistakenly got disabled
>when we followed the ACPI specification more closely
>by ignoring OS updates to that bit.

Not exactly. ACPICA has always preserved the SCI_EN bit. Linux apparently has a "linux-only" patch to ACPICA that disables this.

The recent version of ACPICA change the #define enough such that the patch no longer works.


>-----Original Message-----
>From: Len Brown [mailto:lenb@kernel.org]
>Sent: Friday, May 15, 2009 7:34 PM
>To: Bob Copeland
>Cc: Rafael J. Wysocki; Lin, Ming M; Bjorn Helgaas; Zhao, Yakui; linux-
>kernel@vger.kernel.org; linux-acpi@vger.kernel.org; Moore, Robert
>Subject: [PATCH] ACPI: resume: re-enable SCI-enable workaround
>
>From: Lin Ming <ming.m.lin@intel.com>
>
>The BIOS bug workaround mistakenly got disabled
>when we followed the ACPI specification more closely
>by ignoring OS updates to that bit.
>
>(The BIOS is supposed to update SCI_EN, not the OS)
>
>http://bugzilla.kernel.org/show_bug.cgi?id=13289
>
>Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>Signed-off-by: Len Brown <len.brown@intel.com>
>---
>
>as-applied.
>thanks,
>-Len
>
> drivers/acpi/acpica/aclocal.h |    7 ++++++-
> 1 files changed, 6 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
>index 772ee5c..2ec394a 100644
>--- a/drivers/acpi/acpica/aclocal.h
>+++ b/drivers/acpi/acpica/aclocal.h
>@@ -787,7 +787,12 @@ struct acpi_bit_register_info {
>
> /* For control registers, both ignored and reserved bits must be preserved
>*/
>
>-#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0201	/* Bits 9,
>0(SCI_EN) */
>+/*
>+ * The ACPI spec says to ignore PM1_CTL.SCI_EN (bit 0)
>+ * but we need to be able to write ACPI_BITREG_SCI_ENABLE directly
>+ * as a BIOS workaround on some machines.
>+ */
>+#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0200	/* Bits 9 */
> #define ACPI_PM1_CONTROL_RESERVED_BITS          0xC1F8	/* Bits 14-15,
>3-8 */
> #define ACPI_PM1_CONTROL_PRESERVED_BITS \
> 	       (ACPI_PM1_CONTROL_IGNORED_BITS |
>ACPI_PM1_CONTROL_RESERVED_BITS)
>--
>1.6.3.1.9.g95405b
>

