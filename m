Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZAaCy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZAaCy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZAaCq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:58 -0500
Received: from kroah.org ([198.145.64.141]:54925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755234AbZAaCqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:54 -0500
Date: Fri, 30 Jan 2009 18:40:26 -0800
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
       alan@lxorguk.ukuu.org.uk, Paul Larson <pl@linux.vnet.ibm.com>,
       Eilon Greenstein <eilong@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/32] bnx2x: Block nvram access when the device is inactive
Message-ID: <20090131024026.GV12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bnx2x-block-nvram-access-when-the-device-is-inactive.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eilon Greenstein <eilong@broadcom.com>

commit 2add3acb11a26cc14b54669433ae6ace6406cbf2 upstream.

Don't dump eeprom when bnx2x adapter is down.  Running ethtool -e causes an eeh
without it when the device is down

Signed-off-by: Paul Larson <pl@linux.vnet.ibm.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -8078,6 +8078,9 @@ static int bnx2x_get_eeprom(struct net_d
 	struct bnx2x *bp = netdev_priv(dev);
 	int rc;
 
+	if (!netif_running(dev))
+		return -EAGAIN;
+
 	DP(BNX2X_MSG_NVM, "ethtool_eeprom: cmd %d\n"
 	   DP_LEVEL "  magic 0x%x  offset 0x%x (%d)  len 0x%x (%d)\n",
 	   eeprom->cmd, eeprom->magic, eeprom->offset, eeprom->offset,

