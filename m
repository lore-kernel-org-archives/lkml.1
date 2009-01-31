Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbZAaDFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbZAaDFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZAaCrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:35 -0500
Received: from kroah.org ([198.145.64.141]:55378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754056AbZAaCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:26 -0500
Date: Fri, 30 Jan 2009 18:42:53 -0800
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 19/43] rtl8187: Add termination packet to prevent stall
Message-ID: <20090131024253.GT12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtl8187-add-termination-packet-to-prevent-stall.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 2fcbab044a3faf4d4a6e269148dd1f188303b206 upstream.

The RTL8187 and RTL8187B devices can stall unless an explicit termination
packet is sent.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -263,6 +263,7 @@ static int rtl8187_tx(struct ieee80211_h
 
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
 			  buf, skb->len, rtl8187_tx_cb, skb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc < 0) {
 		usb_free_urb(urb);

