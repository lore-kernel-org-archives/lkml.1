Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZBDTF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZBDTF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbZBDSts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:48 -0500
Received: from kroah.org ([198.145.64.141]:33005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761427AbZBDSti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:38 -0500
Date: Wed, 4 Feb 2009 10:47:04 -0800
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 38/41] ACPI suspend: Blacklist HP xw4600 Workstation for
	old code ordering
Message-ID: <20090204184704.GM25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-blacklist-hp-xw4600-workstation-for-old-code-ordering.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 4fb507b6b764195bb7821cf2baa988f6eb677d30

HP xw4600 Workstation is known to require the "old" (ie. compatible
with ACPI 1.0) suspend code ordering, so blacklist it for this
purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: John Brown <john.brown3@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -344,6 +344,14 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
 		},
 	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "HP xw4600 Workstation",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */

