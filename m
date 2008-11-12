Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYKLAey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYKLAey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYKLA0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:35 -0500
Received: from kroah.org ([198.145.64.141]:42344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753517AbYKLA0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:31 -0500
Date: Tue, 11 Nov 2008 16:23:41 -0800
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
       alan@lxorguk.ukuu.org.uk, Ivan Vecera <ivecera@redhat.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       Martin Capitanio <martin@capitanio.org>,
       Chiaki Ishikawa <chiaki.ishikawa@ubin.jp>,
       Jeff Garzik <jgarzik@redhat.com>, RyanKao <ryankao@realtek.com.tw>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [patch 23/49] r8169: wake up the PHY of the 8168
Message-ID: <20081112002341.GX10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-wake-up-the-phy-of-the-8168.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Upstream as a2de6b89b74b28052e293fdb39975a5a03c432e0

This is typically needed when some other OS puts the PHY
to sleep due to the disabling of WOL options in the BIOS
of the system.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Chiaki Ishikawa <chiaki.ishikawa@ubin.jp>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
Cc: RyanKao <ryankao@realtek.com.tw>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -740,9 +740,13 @@ static int rtl8169_set_speed_xmii(struct
 
 	auto_nego |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
 
-	if ((tp->mac_version == RTL_GIGA_MAC_VER_12) ||
-	    (tp->mac_version == RTL_GIGA_MAC_VER_17)) {
-		/* Vendor specific (0x1f) and reserved (0x0e) MII registers. */
+	if ((tp->mac_version == RTL_GIGA_MAC_VER_11) ||
+	    (tp->mac_version == RTL_GIGA_MAC_VER_12) ||
+	    (tp->mac_version >= RTL_GIGA_MAC_VER_17)) {
+		/*
+		 * Wake up the PHY.
+		 * Vendor specific (0x1f) and reserved (0x0e) MII registers.
+		 */
 		mdio_write(ioaddr, 0x1f, 0x0000);
 		mdio_write(ioaddr, 0x0e, 0x0000);
 	}

-- 
