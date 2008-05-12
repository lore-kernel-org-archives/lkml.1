Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbYELK0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbYELK0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYELK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:26:45 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:52433 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYELK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZERxuCkMLBn3gKAXEnXHCDbhRJ6UrYYOGBLyyXqOCWCptyf0ByUpMa1YWwiI9E743lMvTTQelNJf2gqdVmbBIjgIGX1HqfRb+2wZRZbw4PkzCZCkPtku8uxe8xAIQaqkEaERQiuODvWhQRVv5bBrbzofEw1zayKkENXtYft/4ZQ=
Message-ID: <430c80e90805120326v20a604b0m2cf0d15a5508717c@mail.gmail.com>
Date: Mon, 12 May 2008 15:56:41 +0530
From: "Pranith Kumar" <bobby.prani@gmail.com>
To: paulkf@microgate.com
Subject: [Patch 1/1] Trivial - drivers/char/synclink_gt.c: fix warning
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch fixes the warning i get
drivers/char/synclink_gt.c: In function `put_char':
drivers/char/synclink_gt.c:919: warning: 'ret' might be used
uninitialized in this function

Signed-off-by: D Pranith Kumar

--- linux-2.6.26-rc2/drivers/char/synclink_gt.c.orig	2008-05-12
15:45:36.000000000 +0530
+++ linux-2.6.26-rc2/drivers/char/synclink_gt.c	2008-05-12
15:46:00.000000000 +0530
@@ -916,7 +916,7 @@ static int put_char(struct tty_struct *t
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
-	int ret;
+	int ret = 0;

 	if (sanity_check(info, tty->name, "put_char"))
 		return 0;
