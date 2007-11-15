Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXKOGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXKOGnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXKOGmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXKOGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:31 -0500
Date: Wed, 14 Nov 2007 22:39:48 -0800
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
       Al Viro <viro@zeniv.linux.org.uk>,
       "John W. Linville" <linville@tuxdriver.com>,
       Al Viro <viro@ftp.linux.org.uk>, Dan Williams <dcbw@redhat.com>
Subject: [patch 02/16] libertas: fix endianness breakage
Message-ID: <20071115063948.GB18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-fix-endianness-breakage.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Al Viro <viro@ftp.linux.org.uk>

patch 5707708111ca6c4e9a1160acffdc98a98d95e462 in mainline.

	wep->keytype[] is u8

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/cmd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -185,14 +185,12 @@ static int wlan_cmd_802_11_set_wep(wlan_
 
 			switch (pkey->len) {
 			case KEY_LEN_WEP_40:
-				wep->keytype[i] =
-					cpu_to_le16(cmd_type_wep_40_bit);
+				wep->keytype[i] = cmd_type_wep_40_bit;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				break;
 			case KEY_LEN_WEP_104:
-				wep->keytype[i] =
-					cpu_to_le16(cmd_type_wep_104_bit);
+				wep->keytype[i] = cmd_type_wep_104_bit;
 				memmove(&wep->keymaterial[i], pkey->key,
 				        pkey->len);
 				break;

-- 
