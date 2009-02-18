Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZBRWhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZBRWhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZBRWcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:32:00 -0500
Received: from kroah.org ([198.145.64.141]:34788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757831AbZBRWb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:59 -0500
Date: Wed, 18 Feb 2009 14:29:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Tomas Winkler <tomas.winkler@intel.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [patch 08/36] Bluetooth: Fix TX error path in btsdio driver
Message-ID: <20090218222911.GI10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bluetooth-fix-tx-error-path-in-btsdio-driver.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 7644d63d1348ec044ccd8f775fefe5eb7cbcac69 upstream.

This patch fixes accumulating of the header in case packet was requeued
in the error path.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btsdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdi
 
 	err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
 	if (err < 0) {
+		skb_pull(skb, 4);
 		sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
 		return err;
 	}

