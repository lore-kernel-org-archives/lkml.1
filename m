Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab0BDQFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:05:42 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39426 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176Ab0BDQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:05:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Mk1N48ZOQGIeRNFwBuCY31OoisYN1MSVHa8luiyQgDikV5ddTmN56sIVmiNmKbT1sY
         6JkUsBNBnFIs9qjxtvNR20tgg3jjTtFL2oaZeA8rYz8K/l8tfZ5hcj41yv9nliUO2I/a
         pKBbiGYf0NsjIGK7sx3ESKrzZK6a2E4N7eSeU=
Message-ID: <4B6AF1AF.3010008@gmail.com>
Date: Thu, 04 Feb 2010 17:11:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: ext4_xattr_ibody_set() error ignored in ext4_expand_extra_isize_ea()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling was missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this needed?

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f3a2f7e..b77930c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1302,6 +1302,8 @@ retry:
 
 		/* Remove the chosen entry from the inode */
 		error = ext4_xattr_ibody_set(handle, inode, &i, is);
+		if (error)
+			goto cleanup;
 
 		entry = IFIRST(header);
 		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)
