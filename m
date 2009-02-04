Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbZBDTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbZBDTBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760362AbZBDStg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:36 -0500
Received: from kroah.org ([198.145.64.141]:32853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761386AbZBDSt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:26 -0500
Date: Wed, 4 Feb 2009 10:46:42 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>,
       Fiodor Suietov <fiodor.f.suietov@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 27/41] ACPICA: Add check for invalid handle in
	acpi_get_object_info
Message-ID: <20090204184642.GB25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-add-check-for-invalid-handle-in-acpi_get_object_info.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Fiodor Suietov <fiodor.f.suietov@intel.com>

commit 237a927682a63f02adb542dbdaafe8a81566451d upstream

Return AE_BAD_PARAMETER if input handle is invalid.

http://www.acpica.org/bugzilla/show_bug.cgi?id=474

Signed-off-by: Fiodor Suietov <fiodor.f.suietov@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/namespace/nsxfname.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/namespace/nsxfname.c
+++ b/drivers/acpi/namespace/nsxfname.c
@@ -253,6 +253,7 @@ acpi_get_object_info(acpi_handle handle,
 	node = acpi_ns_map_handle_to_node(handle);
 	if (!node) {
 		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+		status = AE_BAD_PARAMETER;
 		goto cleanup;
 	}
 

