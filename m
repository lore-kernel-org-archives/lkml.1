Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbZBDTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbZBDTHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZBDStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:50 -0500
Received: from kroah.org ([198.145.64.141]:33044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759514AbZBDStl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:41 -0500
Date: Wed, 4 Feb 2009 10:47:10 -0800
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
       alan@lxorguk.ukuu.org.uk, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 41/41] ACPICA: Allow multiple backslash prefix in namepaths
Message-ID: <20090204184710.GP25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-allow-multiple-backslash-prefix-in-namepaths.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit d037c5fd7367548191eab2b376a1d08c4ffaf7ff upstream.

In a fully qualified namepath, allow multiple backslash prefixes.
This can happen because of the use of a double-backslash in strings
(since backslash is the escape character) causing confusion.
ACPICA BZ 739 Lin Ming.

http://www.acpica.org/bugzilla/show_bug.cgi?id=739

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/namespace/nsutils.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/acpi/namespace/nsutils.c
+++ b/drivers/acpi/namespace/nsutils.c
@@ -314,9 +314,15 @@ void acpi_ns_get_internal_name_length(st
 	 *
 	 * strlen() + 1 covers the first name_seg, which has no path separator
 	 */
-	if (acpi_ns_valid_root_prefix(next_external_char[0])) {
+	if (acpi_ns_valid_root_prefix(*next_external_char)) {
 		info->fully_qualified = TRUE;
 		next_external_char++;
+
+		/* Skip redundant root_prefix, like \\_SB.PCI0.SBRG.EC0 */
+
+		while (acpi_ns_valid_root_prefix(*next_external_char)) {
+			next_external_char++;
+		}
 	} else {
 		/*
 		 * Handle Carat prefixes

