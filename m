Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZHGWod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZHGWod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZHGWoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:44:32 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50667 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZHGWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QWGK7FdYQFObCnUc0ogqQQwX6e0PietmhpHwjcf2az1ViUnGOcqmsMFmxZCJSoETOG
         f+7lUneIPpJ+wrBmp0uJt92gbtTyAMba/HGGrjz0i0fx+/jXfFhH3KMz+RYLW8t49vDS
         COMBsOobevrma+sJtNIAbHLuZCXTNjJSjYKQk=
Message-ID: <4A7CAF28.8020908@gmail.com>
Date: Sat, 08 Aug 2009 00:48:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fat: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If len is less or equal to 0, this results in a read of s[-1].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6f27853..114ff6d 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -202,6 +202,9 @@ static inline int vfat_is_used_badchars(const wchar_t *s, int len)
 {
 	int i;
 
+	if (len <= 0)
+		return -EINVAL;
+
 	for (i = 0; i < len; i++)
 		if (vfat_bad_char(s[i]))
 			return -EINVAL;
