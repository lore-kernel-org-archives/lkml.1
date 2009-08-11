Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZHKOct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZHKOct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZHKOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:32:48 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51728 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZHKOcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=P2W3OLB+B9198LAbT/ipJkyUoXxKtIJ2q78z2UOhMSxx5UsuLlPF4B9ezYI+B4RARR
         WxP8Lv0l7K34rpKrku0cSAz3DleTRayajCYAHy0MDQTsSOEDSlsKGGXE8XuhDYVp55SZ
         uMCoJstBbKvgyCD2qiCnsj/dIZnfa2oLT76Z4=
Message-ID: <4A8181FA.2010009@gmail.com>
Date: Tue, 11 Aug 2009 16:36:42 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: samuel.thibault@ens-lyon.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] braille_console: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent write to console_buf[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
If console_newline is true and console_cursor equals WIDTH
c is written to console_buf[-1].

diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index d672cfe..fb4075b 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -322,7 +322,8 @@ static int vt_notifier_call(struct notifier_block *blk,
 					(WIDTH-1) * sizeof(*console_buf));
 			else
 				console_cursor++;
-			console_buf[console_cursor-1] = c;
+			if (console_cursor != 0)
+				console_buf[console_cursor-1] = c;
 			break;
 		}
 		if (console_show)
