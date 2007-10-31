Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbXJaP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbXJaP1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbXJaPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33515 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670AbXJaPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:40 -0400
Date: Wed, 31 Oct 2007 08:11:48 -0700
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
Subject: [patch 14/26] libertas: fix endianness breakage
Message-ID: <20071031151148.GO2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-fix-endianness-breakage.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Al Viro <viro@ftp.linux.org.uk>

patch 5707708111ca6c4e9a1160acffdc98a98d95e462 in mainline.

	wep->keytype[] is u8

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

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
