Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZBQMwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZBQMwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZBQMwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:52:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:28326 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZBQMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EGBUqErSGHyEU69qgHH4coFPoDYTJwG4w6swzBiK5acfNKXBIW3+SmldgU0t8BXxJF
         EfM1TNtq5a0kPnewuO/vWRBFn29DW6d0Lri7EkaeYa7wziYZIi2nkR5gH3CdKdl3KHmt
         CJ6UbUuf429RkcQ1BXoNj1CVwOj5sh106FbEI=
Message-ID: <499AB31C.9000200@gmail.com>
Date: Tue, 17 Feb 2009 13:52:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] rio: Add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#include <stdio.h>

int main(int argc, char* argv[])
{
	printf ("%d\n", 1 + (1 == 0) ? 2 : 4);
	return 0;
}

gcc test.c;a.out
2

I think this was intended? otherwise we could also do

return tty->index || (tty->driver == rio_driver) ? 0 : 256;
--------------------------->8-------------8<------------------------------
Add missing parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 2e8a6ee..ce81da5 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -333,7 +333,7 @@ void rio_copy_to_card(void *from, void __iomem *to, int len)
 
 int rio_minor(struct tty_struct *tty)
 {
-	return tty->index + (tty->driver == rio_driver) ? 0 : 256;
+	return tty->index + ((tty->driver == rio_driver) ? 0 : 256);
 }
 
 static int rio_set_real_termios(void *ptr)

