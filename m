Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923Ab0CMAzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:55:13 -0500
Received: from kroah.org ([198.145.64.141]:46925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935423Ab0CMAbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:33 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002710.217337979@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [057/145] rndis_wlan: disable stall workaround
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 77593ae28c4c134eaf28ef34ecac3cd4464ecd6e upstream.

Stall workaround doesn't work with bcm4320a devices like with bcm4320b.
This workaround actually causes more stalls/device freeze on bcm4320a.
Therefore disable stall workaround by default.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rndis_wlan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -83,11 +83,11 @@ MODULE_PARM_DESC(roamdelta,
 	"set roaming tendency: 0=aggressive, 1=moderate, "
 				"2=conservative (default: moderate)");
 
-static int modparam_workaround_interval = 500;
+static int modparam_workaround_interval;
 module_param_named(workaround_interval, modparam_workaround_interval,
 							int, 0444);
 MODULE_PARM_DESC(workaround_interval,
-	"set stall workaround interval in msecs (default: 500)");
+	"set stall workaround interval in msecs (0=disabled) (default: 0)");
 
 
 /* various RNDIS OID defs */
@@ -2550,7 +2550,7 @@ static void rndis_device_poller(struct w
 	/* Workaround transfer stalls on poor quality links.
 	 * TODO: find right way to fix these stalls (as stalls do not happen
 	 * with ndiswrapper/windows driver). */
-	if (priv->last_qual <= 25) {
+	if (priv->param_workaround_interval > 0 && priv->last_qual <= 25) {
 		/* Decrease stats worker interval to catch stalls.
 		 * faster. Faster than 400-500ms causes packet loss,
 		 * Slower doesn't catch stalls fast enough.


