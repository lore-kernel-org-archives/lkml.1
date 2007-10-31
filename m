Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbXJaP2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbXJaP2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbXJaPYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33559 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbXJaPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:48 -0400
Date: Wed, 31 Oct 2007 08:11:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       warmcat <andy@warmcat.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 16/26] Add get_unaligned to ieee80211_get_radiotap_len
Message-ID: <20071031151155.GQ2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-get_unaligned-to-ieee80211_get_radiotap_len.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Andy Green <andy@warmcat.com>

patch dfe6e81deaa79c85086c0cc8d85b229e444ab97f in mainline.

ieee80211_get_radiotap_len() tries to dereference radiotap length without
taking care that it is completely unaligned and get_unaligned()
is required.

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -24,6 +24,7 @@
 #include <linux/compiler.h>
 #include <linux/bitmap.h>
 #include <net/cfg80211.h>
+#include <asm/unaligned.h>
 
 #include "ieee80211_common.h"
 #include "ieee80211_i.h"
@@ -338,7 +339,7 @@ static int ieee80211_get_radiotap_len(st
 	struct ieee80211_radiotap_header *hdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 
-	return le16_to_cpu(hdr->it_len);
+	return le16_to_cpu(get_unaligned(&hdr->it_len));
 }
 
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP

-- 
