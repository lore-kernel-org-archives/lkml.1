Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZLGNYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZLGNYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbZLGNYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:24:13 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43796 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbZLGNYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:24:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=V++ynEclDAguNuZU2X0UQz+XSX+3t9WYveQHDdB/nPRX8lJtw5FYPHduil1PxKLuZJ
         TALwp8BZBEv5QxkTTGveJsKVEE8Zt9X+mGvbKWnqFj3bhsTDWKQF66+6Dkhlny8GwMvh
         nU4kRa9gh83H3bkR+bIGfEkC9l7dxghpQh6EM=
Message-ID: <4B1D0243.3030008@gmail.com>
Date: Mon, 07 Dec 2009 14:25:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
CC: linux-security-module@vger.kernel.org
Subject: [PATCH] keys: PTR_ERR return of wrong pointer in keyctl_get_security()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 security/keys/keyctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 06ec722..5f830bc 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1194,7 +1194,7 @@ long keyctl_get_security(key_serial_t keyid,
 		 * have the authorisation token handy */
 		instkey = key_get_instantiation_authkey(keyid);
 		if (IS_ERR(instkey))
-			return PTR_ERR(key_ref);
+			return PTR_ERR(instkey);
 		key_put(instkey);
 
 		key_ref = lookup_user_key(keyid, KEY_LOOKUP_PARTIAL, 0);
