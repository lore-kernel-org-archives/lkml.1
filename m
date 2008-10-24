Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYJXErg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYJXErg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYJXEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:40 -0400
Received: from kroah.org ([198.145.64.141]:51919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753030AbYJXEja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:30 -0400
Date: Thu, 23 Oct 2008 21:35:04 -0700
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
       Len Brown <len.brown@intel.com>
Subject: [patch 22/27] ACPI suspend: Blacklist HP xw4600 Workstation for
	old code ordering
Message-ID: <20081024043504.GW30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-blacklist-hp-xw4600-workstation-for-old-code-ordering.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 4fb507b6b764195bb7821cf2baa988f6eb677d30 upstream

HP xw4600 Workstation is known to require the "old" (ie. compatible
with ACPI 1.0) suspend code ordering, so blacklist it for this
purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: John Brown <john.brown3@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -298,6 +298,14 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
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

-- 
