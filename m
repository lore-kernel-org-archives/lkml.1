Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbXHWWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbXHWWhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXHWW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbXHWW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:19 -0400
Date: Thu, 23 Aug 2007 15:27:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/28] PPP: Fix PPP buffer sizing.
Message-ID: <20070823222730.GT18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ppp-fix-ppp-buffer-sizing.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>

This patch addresses the issue with "osize too small" errors in mppe
encryption.  The patch fixes the issue with wrong output buffer size
being passed to ppp decompression routine.

--------------------
As pointed out by Suresh Mahalingam, the issue addressed by
ppp-fix-osize-too-small-errors-when-decoding patch is not fully resolved yet.
The size of allocated output buffer is correct, however it size passed to
ppp->rcomp->decompress in ppp_generic.c if wrong. The patch fixes that.
--------------------

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ppp_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1726,7 +1726,7 @@ ppp_decompress_frame(struct ppp *ppp, st
 		}
 		/* the decompressor still expects the A/C bytes in the hdr */
 		len = ppp->rcomp->decompress(ppp->rc_state, skb->data - 2,
-				skb->len + 2, ns->data, ppp->mru + PPP_HDRLEN);
+				skb->len + 2, ns->data, obuff_size);
 		if (len < 0) {
 			/* Pass the compressed frame to pppd as an
 			   error indication. */

-- 
