Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbZCNBet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbZCNBet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZCNBUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:42 -0400
Received: from kroah.org ([198.145.64.141]:35143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753473AbZCNBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:37 2009
Message-Id: <20090314011037.297941272@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:17 -0700
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
       alan@lxorguk.ukuu.org.uk, Michael Spang <mspang@csclub.uwaterloo.ca>,
       Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>,
       Andi Kleen <ak@linux.intel.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 040/114] acer-wmi: fix regression in backlight detection
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=acer-wmi-fix-regression-in-backlight-detection.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Spang <mspang@csclub.uwaterloo.ca>

commit 1ba869ec581fd9078b684c56c399ffe3d2345e27 upstream.

Currently we disable the Acer WMI backlight device if there is no ACPI
backlight device.  As a result, we end up with no backlight device at all.
 We should instead disable it if there is an ACPI device, as the other
laptop drivers do.  This regression was introduced in febf2d9 ("Acer-WMI:
fingers off backlight if video.ko is serving this functionality").

Each laptop driver with backlight support got a similar change around
febf2d9.  The changes to the other drivers look correct; see e.g.
a598c82f for a similar but correct change.  The regression is also in
2.6.28.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
Acked-by: Thomas Renninger <trenn@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -1297,7 +1297,7 @@ static int __init acer_wmi_init(void)
 
 	set_quirks();
 
-	if (!acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
+	if (acpi_video_backlight_support() && has_cap(ACER_CAP_BRIGHTNESS)) {
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 		printk(ACER_INFO "Brightness must be controlled by "
 		       "generic video driver\n");


