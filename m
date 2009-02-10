Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZBJTHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZBJTHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZBJTDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:35 -0500
Received: from kroah.org ([198.145.64.141]:53679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754906AbZBJTDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:34 -0500
Date: Tue, 10 Feb 2009 11:00:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 10/53] ACPI: Enable bit 11 in _PDC to advertise hw coord
Message-ID: <20090210190000.GK14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-enable-bit-11-in-_pdc-to-advertise-hw-coord.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

commit d96f94c604453f87fe24154b87e1e9a3a72511f8 upstream.

Bit 11 in intel PDC definitions is meant for OS capability to handle
hardware coordination of P-states. In Linux we have always supported
hwardware coordination of P-states. Just let the BIOSes know that we
support it, by setting this bit.

Some BIOSes use this bit to choose between hardware or software coordination
and without this change below, BIOSes switch to software coordination, which
is not very optimal in terms of power consumption and extra wakeups from idle.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/acpi/pdc_intel.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/acpi/pdc_intel.h
+++ b/include/acpi/pdc_intel.h
@@ -14,6 +14,7 @@
 #define ACPI_PDC_SMP_T_SWCOORD		(0x0080)
 #define ACPI_PDC_C_C1_FFH		(0x0100)
 #define ACPI_PDC_C_C2C3_FFH		(0x0200)
+#define ACPI_PDC_SMP_P_HWCOORD		(0x0800)
 
 #define ACPI_PDC_EST_CAPABILITY_SMP	(ACPI_PDC_SMP_C1PT | \
 					 ACPI_PDC_C_C1_HALT | \
@@ -22,6 +23,7 @@
 #define ACPI_PDC_EST_CAPABILITY_SWSMP	(ACPI_PDC_SMP_C1PT | \
 					 ACPI_PDC_C_C1_HALT | \
 					 ACPI_PDC_SMP_P_SWCOORD | \
+					 ACPI_PDC_SMP_P_HWCOORD | \
 					 ACPI_PDC_P_FFH)
 
 #define ACPI_PDC_C_CAPABILITY_SMP	(ACPI_PDC_SMP_C2C3  | \

