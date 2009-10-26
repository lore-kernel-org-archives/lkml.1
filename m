Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZJZORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZJZORj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZJZORi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:17:38 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50416 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZJZORh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Jin7oCw3ju63McYMi38tIN8HN28FgV/t52u8/s/Z4FbYO803DSgKI7Uv+GR1RXBSl8
         NQz0obgpT/jzPf8VkFeHH/h8hSIXvLC4Mbh8gtvDMbGguFtitZkCXNBveAKqY2GCLh1+
         f0fiytbBhsSySvPOE61KzmG3CSgXWrTnWHUAE=
Message-ID: <4AE5B1FB.2050306@gmail.com>
Date: Mon, 26 Oct 2009 15:28:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] airo: Reorder tests, check bounds before element
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test whether index is within bounds before reading the element

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/airo.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 7116a1a..abf896a 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4790,9 +4790,8 @@ static int proc_stats_rid_open( struct inode *inode,
 static int get_dec_u16( char *buffer, int *start, int limit ) {
 	u16 value;
 	int valid = 0;
-	for( value = 0; buffer[*start] >= '0' &&
-		     buffer[*start] <= '9' &&
-		     *start < limit; (*start)++ ) {
+	for (value = 0; *start < limit && buffer[*start] >= '0' &&
+			buffer[*start] <= '9'; (*start)++) {
 		valid = 1;
 		value *= 10;
 		value += buffer[*start] - '0';

