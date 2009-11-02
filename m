Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZKBQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZKBQPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZKBQPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:15:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:11680 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbZKBQPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=AcaSHfCMSYfwp0k93i+00l4enctP/n3IySLXe/yXNpMNV4kGQCdxBeGu0zXTHckIG3
         dzLc6FZVn6LkQ+ZMXIyF9Wh3u9F34tuVPVPhnJEvmdCnXluei5KKTo5v/q9BP2qrKOK3
         YZUem2SThbICafx3nW4qWoVs3GFCRXaLslHSM=
Message-ID: <4AEF0837.8080503@gmail.com>
Date: Mon, 02 Nov 2009 17:26:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sms-cards.c: Ensure index is positive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index is signed, make sure it is not negative
when we read the array element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/dvb/siano/sms-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index 0420e28..52f0dac 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -99,7 +99,7 @@ static struct sms_board sms_boards[] = {
 
 struct sms_board *sms_get_board(int id)
 {
-	BUG_ON(id >= ARRAY_SIZE(sms_boards));
+	BUG_ON(id >= ARRAY_SIZE(sms_boards) || id < 0);
 
 	return &sms_boards[id];
 }
