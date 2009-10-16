Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbZJPPFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbZJPPFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZJPPFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:05:41 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53114 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428AbZJPPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=LTdwxhfd0LfAcrhY8QBgH87Kr1lzfgWc1XHXTlkUrb9t7lbAujAj4yYo8+3kXX/3cr
         Qlo78nYCgi+S5Iulc3hyaoIUoImjZfgeVNCoPH2uLsXf7DMN0SqtcNk32R3SIdeKsLg9
         Ywe54BcujeYGKNZzkF+fLUUdA+ulbbLm/MvDA=
Message-ID: <4AD88DE1.1080900@gmail.com>
Date: Fri, 16 Oct 2009 17:14:41 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] befs: redundant test on unsigned in befs_get_block()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block is unsigned, this test appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or is a different test required?

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 33baf27..3ab1336 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -128,13 +128,6 @@ befs_get_block(struct inode *inode, sector_t block,
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   inode->i_ino, block);
 
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   block, inode->i_ino);
-		return -EIO;
-	}
-
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
 			   "block %ld in inode %lu", block, inode->i_ino);
