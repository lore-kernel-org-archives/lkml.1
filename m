Return-Path: <linux-kernel-owner+w=401wt.eu-S935075AbZLGNcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075AbZLGNcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935065AbZLGNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:32:32 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62534 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935064AbZLGNc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:32:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Uu8OaqmiVeZ+Zq9y6NgOX5HpzbQAYUwI3/02TzvIoE5RRoFsuV/alUqAs9Wg1OKRZh
         VSzr4HHj3Vltmr5raNfWDE5QA6hY47r8qUOxjIkUJTk/mAaeu1DoEw4QLraat6GrAu/S
         Cp0AkxzLXuwZ9+jWeHZ5niJuqV7m50f9z7Uao=
Message-ID: <4B1D0433.3080506@gmail.com>
Date: Mon, 07 Dec 2009 14:33:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tty: PTR_ERR return of wrong pointer in fs3270_open()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/s390/char/fs3270.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 097d384..2ae58d0 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -465,7 +465,7 @@ fs3270_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(ib)) {
 		raw3270_put_view(&fp->view);
 		raw3270_del_view(&fp->view);
-		rc = PTR_ERR(fp);
+		rc = PTR_ERR(ib);
 		goto out;
 	}
 	fp->rdbuf = ib;
