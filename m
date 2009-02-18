Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZBRWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZBRWhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZBRWcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:32:03 -0500
Received: from kroah.org ([198.145.64.141]:34793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757857AbZBRWb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:59 -0500
Date: Wed, 18 Feb 2009 14:29:13 -0800
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
       alan@lxorguk.ukuu.org.uk, Sergio Luis <sergio@larces.uece.br>,
       "David S. Miller" <davem@davemloft.net>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [patch 09/36] btsdio: free sk_buff with kfree_skb
Message-ID: <20090218222913.GJ10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="btsdio-free-sk_buff-with-kfree_skb.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergio Luis <sergio@larces.uece.br>

commit cbfd24a75f98fe731547d3bc995f3a1f1fed6b20 upstream.

free sk_buff with kfree_skb, instead of kree

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btsdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -153,7 +153,7 @@ static int btsdio_rx_packet(struct btsdi
 
 	err = sdio_readsb(data->func, skb->data, REG_RDAT, len - 4);
 	if (err < 0) {
-		kfree(skb);
+		kfree_skb(skb);
 		return err;
 	}
 

