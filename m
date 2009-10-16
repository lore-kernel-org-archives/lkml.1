Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbZJPP47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbZJPP47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760425AbZJPP46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:56:58 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:32891 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760350AbZJPP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Dl+FRwNipbrYZaOcOHQO8IF75ZiJytcFTC9N4OeeD56lzjdp/opqkCVdIHf7hbLL5V
         HP7GhOEyUyhIjoYgCmKfvQziyuTXB8lY8/nRY81nMDsGxCqrYGjU4awdRIA+yIrD2r+/
         7ZjgZnJ0PNXmunbrtwoA6gZj6dxE+FkpvmY2o=
Message-ID: <4AD899E6.9020003@gmail.com>
Date: Fri, 16 Oct 2009 18:05:58 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       anton@samba.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hvc_console: Fix test on unsigned in hvc_console_print()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vtermnos[] is unsigned, so this test was wrong.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index a632f25..28e4758 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -146,7 +146,7 @@ static void hvc_console_print(struct console *co, const char *b,
 		return;
 
 	/* This console adapter was removed so it is not usable. */
-	if (vtermnos[index] < 0)
+	if (vtermnos[index] == -1)
 		return;
 
 	while (count > 0 || i > 0) {
