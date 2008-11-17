Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYKQHYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYKQHYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYKQHVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:06 -0500
Received: from kroah.org ([198.145.64.141]:38263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267AbYKQHU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:20:56 -0500
Date: Sun, 16 Nov 2008 23:14:49 -0800
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
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/46] hostap: pad the skb->cb usage in lieu of a proper fix
Message-ID: <20081117071449.GK29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hostap-pad-the-skb-cb-usage-in-lieu-of-a-proper-fix.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit f7cd168645dda3e9067f24fabbfa787f9a237488 upstream.

Like mac80211 did, this driver makes 'clever' use of skb->cb to pass
information along with an skb as it is requeued from the virtual device
to the physical wireless device.  Unfortunately, that trick no longer
works...

Unlike mac80211, code complexity and driver apathy makes this hack
the best option we have in the short run.  Hopefully someone will
eventually be motivated to code a proper fix before all the effected
hardware dies.

(Above text by me.  Johannes officially disavows all knowledge of this
hack. -- JWL)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/hostap/hostap_wlan.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -918,9 +918,12 @@ struct hostap_interface {
 
 /*
  * TX meta data - stored in skb->cb buffer, so this must not be increased over
- * the 40-byte limit
+ * the 48-byte limit.
+ * THE PADDING THIS STARTS WITH IS A HORRIBLE HACK THAT SHOULD NOT LIVE
+ * TO SEE THE DAY.
  */
 struct hostap_skb_tx_data {
+	unsigned int __padding_for_default_qdiscs;
 	u32 magic; /* HOSTAP_SKB_TX_DATA_MAGIC */
 	u8 rate; /* transmit rate */
 #define HOSTAP_TX_FLAGS_WDS BIT(0)

-- 
