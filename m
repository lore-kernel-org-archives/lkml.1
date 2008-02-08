Return-Path: <linux-kernel-owner+w=401wt.eu-S934614AbYBHLWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbYBHLWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbYBHLWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:22:03 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:55649 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYBHLWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=v+kA103CSqYscw2nxoi30W8KQp4kZ5vmTynGh9B0djEPDLyIqWHGBUa88qh9lMEN2j2jsAfUVfklRPVdUTpaaOTeHYYfc3nKVOY739meJyYA+jValLv6kIA0+Xg3IHKzwzBg0G29iUn0yk4zCfHKN29YmI7zkb5DfQ7BEvn0VO0=
Message-ID: <8b67d60802080321o6f6c8ca7x768d911a6f1fba0b@mail.gmail.com>
Date: Fri, 8 Feb 2008 11:21:58 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: jgarzik@pobox.com, "Paul Mundt" <lethal@linux-sh.org>
Subject: [PATCH] 8139too fix for Dreamcast
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates the 8139too driver to work with recently added
(a724605cb7a66d423a494a395f9a8ba871b8a1eb) declared coherent memory
patch for the Dreamcast.

Jeff - I am assuming you are still the maintainer and I guess Paul
should also ack this as it is SH related.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

-----


diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index d373545..80f1cce 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -168,7 +168,7 @@ static int debug = -1;
  * Warning: 64K ring has hardware issues and may lock up.
  */
 #if defined(CONFIG_SH_DREAMCAST)
-#define RX_BUF_IDX	1	/* 16K ring */
+#define RX_BUF_IDX 0	/* 8K ring */
 #else
 #define RX_BUF_IDX	2	/* 32K ring */
 #endif
