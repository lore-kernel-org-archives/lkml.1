Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZETSrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZETSrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZETSrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:47:40 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:55462 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZETSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:47:39 -0400
Date: Wed, 20 May 2009 11:47:13 -0700
From: "Larry H." <research@subreption.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       linux-wireless@vger.kernel.org
Subject: [patch 2/5] Apply the PG_sensitive flag to mac80211 WEP key
	handling
Message-ID: <20090520184713.GB10756@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deploys the use of the PG_sensitive page allocator flag
within the mac80211 driver, more specifically the handling of WEP
RC4 keys during encryption and decryption.

Signed-off-by: Larry H. <research@subreption.com>

---
 net/mac80211/wep.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/net/mac80211/wep.c
===================================================================
--- linux-2.6.orig/net/mac80211/wep.c
+++ linux-2.6/net/mac80211/wep.c
@@ -155,7 +155,7 @@ int ieee80211_wep_encrypt(struct ieee802
 		return -1;
 
 	klen = 3 + key->conf.keylen;
-	rc4key = kmalloc(klen, GFP_ATOMIC);
+	rc4key = kmalloc(klen, GFP_ATOMIC | GFP_SENSITIVE);
 	if (!rc4key)
 		return -1;
 
@@ -243,7 +243,7 @@ int ieee80211_wep_decrypt(struct ieee802
 
 	klen = 3 + key->conf.keylen;
 
-	rc4key = kmalloc(klen, GFP_ATOMIC);
+	rc4key = kmalloc(klen, GFP_ATOMIC | GFP_SENSITIVE);
 	if (!rc4key)
 		return -1;
 
