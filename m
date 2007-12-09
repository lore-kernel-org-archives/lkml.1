Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXLIVWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXLIVWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXLIVW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:22:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:39288 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXLIVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=YalgUceJdqxYytnNn4vjHOK1e5q38juS9bvBD1+LzJcBN8imlgCIAntGn1sWVVa65xcd2LkZNzw+092eUsjwDIj5R2GQFnkd7kokevu2A6HrtBkz8SJ7NyC0JFz2AW2NbYPexsk697SW/m0LWjNbV/0E0AjJZzCOx2LqTVe2Vh0=
Date: Sun, 9 Dec 2007 22:23:42 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usb/storage/initializers.c: fix signedness difference
Message-ID: <20071209212337.GA9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb/storage/initializers.c: fix signedness difference

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 drivers/usb/storage/initializers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index ee5b42a..187dd1e 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -66,7 +66,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 {
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap*) us->iobuf;
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap*) us->iobuf;
-	int res, partial;
+	int res;
+	unsigned int partial;
 	static char init_string[] = "\xec\x0a\x06\x00$PCCHIPS";

 	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");
