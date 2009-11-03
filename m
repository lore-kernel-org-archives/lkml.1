Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZKCWhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZKCWhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZKCWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:37:37 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38607 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZKCWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xNIbFJgtxrFUQAb0RcdiKzjw3fc37N1ces7HFbARQs2xLU15YH0zYstJy8F7aHEzU6
         CcO/FWuOGzs6yfMWynN6Mu1AsHBQEx5svk9o9aEzAxfcDbbrQyQuayisEyFwlJ2P4ZbS
         +8cgAvJBFUEjJpK8SS8n5lA38iIbChDQo5euU=
Message-ID: <4AF0B35A.8080400@gmail.com>
Date: Tue, 03 Nov 2009 23:48:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net
Subject: [PATCH] dst: Fix parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`|' has a higher precedence than `?' so since MSG_WAITALL is
defined 0x100, MSG_MORE was always written to the msg_flag.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/dst/state.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dst/state.c b/drivers/staging/dst/state.c
index d057e52..bccbd6d 100644
--- a/drivers/staging/dst/state.c
+++ b/drivers/staging/dst/state.c
@@ -121,7 +121,7 @@ int dst_data_send_header(struct socket *sock,
 	msg.msg_namelen = 0;
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
-	msg.msg_flags = MSG_WAITALL | (more)?MSG_MORE:0;
+	msg.msg_flags = MSG_WAITALL | (more ? MSG_MORE : 0);
 
 	err = kernel_sendmsg(sock, &msg, &iov, 1, iov.iov_len);
 	if (err != size) {
