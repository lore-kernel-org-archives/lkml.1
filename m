Return-Path: <linux-kernel-owner+w=401wt.eu-S935021AbZLGNR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbZLGNR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934923AbZLGNR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:17:28 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45008 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934890AbZLGNR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WXRSzd1+yL0jPKH676995eVVXYN13PuW5uMHKMBRY3nvWD6hKIZrNh5JFgOeG9Ym75
         4iXdttmfhtdZwbQfzXnECi5iAUcT8+m7qZD2fTIAUc/duE1a+3aESlLFkT+tkhDOgK6+
         MtQ0mNNEwxShiScfPTDLgiD0BTwNmrIjxLRtY=
Message-ID: <4B1D00B0.5030209@gmail.com>
Date: Mon, 07 Dec 2009 14:18:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, wein@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH] dasd: PTR_ERR return of wrong pointer in dasd_alias_make_device_known_to_lcu()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/s390/block/dasd_alias.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless I am mistaken?

diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 70a008c..fa37148 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -217,7 +217,7 @@ int dasd_alias_make_device_known_to_lcu(struct dasd_device *device)
 		spin_unlock_irqrestore(&aliastree.lock, flags);
 		newlcu = _allocate_lcu(uid);
 		if (IS_ERR(newlcu))
-			return PTR_ERR(lcu);
+			return PTR_ERR(newlcu);
 		spin_lock_irqsave(&aliastree.lock, flags);
 		lcu = _find_lcu(server, uid);
 		if (!lcu) {
