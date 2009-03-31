Return-Path: <linux-kernel-owner+w=401wt.eu-S1764885AbZCaXb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764885AbZCaXb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763671AbZCaXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:08 -0400
Received: from sous-sol.org ([216.99.217.87]:33225 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763637AbZCaXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:04 -0400
Message-Id: <20090331231535.711519749@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, Lorenzo Nava <navalorenx@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, John W Linville <linville@tuxdriver.com>
Subject: [patch 19/45] b43: fix b43_plcp_get_bitrate_idx_ofdm return type
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=b43-fix-b43_plcp_get_bitrate_idx_ofdm-return-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Lorenzo Nava <navalorenx@gmail.com>

upstream commit: a3c0b87c4f21911fb7185902dd13f0e3cd7f33f7

This patch fixes the return type of b43_plcp_get_bitrate_idx_ofdm. If
the plcp contains an error, the function return value is 255 instead
of -1, and the packet was not dropped. This causes a warning in
__ieee80211_rx function because rate idx is out of range.

Cc: stable@kernel.org
Signed-off-by: Lorenzo Nava <navalorenx@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/b43/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -50,7 +50,7 @@ static int b43_plcp_get_bitrate_idx_cck(
 }
 
 /* Extract the bitrate index out of an OFDM PLCP header. */
-static u8 b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
+static int b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
 {
 	int base = aphy ? 0 : 4;
 

