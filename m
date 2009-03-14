Return-Path: <linux-kernel-owner+w=401wt.eu-S1765667AbZCNCCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765667AbZCNCCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZCNBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:07 -0400
Received: from kroah.org ([198.145.64.141]:35870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754403AbZCNBVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:47 2009
Message-Id: <20090314011047.577830206@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Len Brown <lenb@kernel.org>
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
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org,
       Lin Ming <ming.m.lin@intel.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [patch 109/114] ACPI: fix broken usage of acpi_ut_get_node_name()
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=acpi-fix-broken-usage-of-acpi_ut_get_node_name.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

This issue was fixed indirectly in mainline by commit
60a4ce7f4148155d3f28eea4a213f7ee47cd57b7.

acpi_ut_get_node_name() returns a four char fixed-size array, not
NULL-terminated.

This is the minimal fix for stable 2.6.28.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org
Acked-by: Lin Ming <ming.m.lin@intel.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -151,7 +151,7 @@ static int acpi_power_get_state(acpi_han
 	*state = (sta & 0x01)?ACPI_POWER_RESOURCE_STATE_ON:
 			      ACPI_POWER_RESOURCE_STATE_OFF;
 
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Resource [%s] is %s\n",
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Resource [%4.4s] is %s\n",
 			  acpi_ut_get_node_name(handle),
 				*state ? "on" : "off"));
 


