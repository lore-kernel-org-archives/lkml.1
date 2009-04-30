Return-Path: <linux-kernel-owner+w=401wt.eu-S1765182AbZD3RNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765182AbZD3RNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764412AbZD3RHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:31 -0400
Received: from kroah.org ([198.145.64.141]:56255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764284AbZD3RHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:40 2009
Message-Id: <20090430165740.509086693@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:04 -0700
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
       alan@lxorguk.ukuu.org.uk, Lorenzo Nava <navalorenx@gmail.com>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 15/88] b43: fix b43_plcp_get_bitrate_idx_ofdm return type
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0019-b43-fix-b43_plcp_get_bitrate_idx_ofdm-return-type.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lorenzo Nava <navalorenx@gmail.com>

upstream commit: a3c0b87c4f21911fb7185902dd13f0e3cd7f33f7

This patch fixes the return type of b43_plcp_get_bitrate_idx_ofdm. If
the plcp contains an error, the function return value is 255 instead
of -1, and the packet was not dropped. This causes a warning in
__ieee80211_rx function because rate idx is out of range.

Signed-off-by: Lorenzo Nava <navalorenx@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/b43/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -51,7 +51,7 @@ static int b43_plcp_get_bitrate_idx_cck(
 }
 
 /* Extract the bitrate index out of an OFDM PLCP header. */
-static u8 b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
+static int b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
 {
 	int base = aphy ? 0 : 4;
 


