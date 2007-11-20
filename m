Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbXKTSbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbXKTSbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761571AbXKTS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51862 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761567AbXKTS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:43 -0500
Date: Tue, 20 Nov 2007 10:24:23 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Tobias Powalowski <t.powa@gmx.de>
Subject: [patch 14/29] ACPI: VIDEO: Adjust current level to closest
	available one.
Message-ID: <20071120182423.GP28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-video-adjust-current-level-to-closest-available-one.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

patch 63f0edfc0b7f8058f9d3f9b572615ec97ae011ba in mainline.

ACPI: VIDEO: Adjust current level to closest available one.


Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Tobias Powalowski <t.powa@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/video.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1633,9 +1633,20 @@ static int
 acpi_video_get_next_level(struct acpi_video_device *device,
 			  u32 level_current, u32 event)
 {
-	int min, max, min_above, max_below, i, l;
+	int min, max, min_above, max_below, i, l, delta = 255;
 	max = max_below = 0;
 	min = min_above = 255;
+	/* Find closest level to level_current */
+	for (i = 0; i < device->brightness->count; i++) {
+		l = device->brightness->levels[i];
+		if (abs(l - level_current) < abs(delta)) {
+			delta = l - level_current;
+			if (!delta)
+				break;
+		}
+	}
+	/* Ajust level_current to closest available level */
+	level_current += delta;
 	for (i = 0; i < device->brightness->count; i++) {
 		l = device->brightness->levels[i];
 		if (l < min)

-- 
