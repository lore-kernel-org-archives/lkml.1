Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYKQHgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYKQHgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKQHVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:45 -0500
Received: from kroah.org ([198.145.64.141]:38745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbYKQHVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:42 -0500
Date: Sun, 16 Nov 2008 23:17:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 42/46] ACPI: EC: revert msleep patch
Message-ID: <20081117071705.GQ29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-ec-revert-msleep-patch.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 1cfe62c8010ac56e1bd3827e30386a87cc2f3594 upstream.

With the better solution for EC interrupt storm issue,
there is no need to use msleep over udelay.

References:
	http://bugzilla.kernel.org/show_bug.cgi?id=11810
	http://bugzilla.kernel.org/show_bug.cgi?id=10724

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -239,10 +239,10 @@ static int ec_check_sci(struct acpi_ec *
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
-	msleep(1);
+	udelay(ACPI_EC_UDELAY);
 	while (time_before(jiffies, delay)) {
 		gpe_transaction(ec, acpi_ec_read_status(ec));
-		msleep(1);
+		udelay(ACPI_EC_UDELAY);
 		if (ec_transaction_done(ec))
 			return 0;
 	}

-- 
