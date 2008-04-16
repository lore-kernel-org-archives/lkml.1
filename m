Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYDPXYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYDPXYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbYDPXYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:24:20 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:34395 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbYDPXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J80kQAYJE9khA6A7bdW0Brip4aKNF6UtSCjkPAc00QHa4lhixG7bAfSANv4bb7PAFvBNXg71RXlsQ38iwo3w58V4Lgr9INticBwUitrJ2b2FQWgUQR4572HlGfKi2jHk9C8XYUtCd29R5i4Ja0eO0BcNHP8F3f4RkOsUSVC7wts=
Subject: [PATCH-mm 2/5] mac80211: tkip.c remove unused function, remove
	some extra lines
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Benc <jbenc@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 16:24:25 -0700
Message-Id: <1208388265.11920.126.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for move to a tkip context struct.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   24 ++++--------------------
 net/mac80211/tkip.h |    2 --
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 1c5a46a..f5815ac 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -18,15 +18,12 @@
 #include "tkip.h"
 #include "wep.h"
 
-
-/* TKIP key mixing functions */
-
-
 #define PHASE1_LOOP_COUNT 8
 
-
-/* 2-byte by 2-byte subset of the full AES S-box table; second part of this
- * table is identical to first part but byte-swapped */
+/*
+ * 2-byte by 2-byte subset of the full AES S-box table; second part of this
+ * table is identical to first part but byte-swapped
+ */
 static const u16 tkip_sbox[256] =
 {
 	0xC6A5, 0xF884, 0xEE99, 0xF68D, 0xFF0D, 0xD6BD, 0xDEB1, 0x9154,
@@ -95,7 +92,6 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 	}
 }
 
-
 static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 			       u8 *rc4key)
 {
@@ -132,7 +128,6 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 		put_unaligned_le16(ppk[i], rc4key + i);
 }
 
-
 /* Add TKIP IV and Ext. IV at @pos. @iv0, @iv1, and @iv2 are the first octets
  * of the IV. Returns pointer to the octet following IVs (i.e., beginning of
  * the packet payload). */
@@ -147,14 +142,6 @@ u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 	return pos + 4;
 }
 
-
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key)
-{
-	tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
-			   key->u.tkip.iv32, phase1key);
-}
-
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key)
 {
@@ -237,7 +224,6 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
-
 /* Decrypt packet payload with TKIP using @key. @pos is a pointer to the
  * beginning of the buffer containing IEEE 802.11 header payload, i.e.,
  * including IV, Ext. IV, real data, Michael MIC, ICV. @payload_len is the
@@ -365,5 +351,3 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 
 	return res;
 }
-
-
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index b7c2ee7..c9ac2f4 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -15,8 +15,6 @@
 
 u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2);
-void ieee80211_tkip_gen_phase1key(struct ieee80211_key *key, u8 *ta,
-				  u16 *phase1key);
 void ieee80211_tkip_gen_rc4key(struct ieee80211_key *key, u8 *ta,
 			       u8 *rc4key);
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
-- 
1.5.5.144.g3e42


