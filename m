Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZABMLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZABMLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZABMLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:11:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:26219 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbZABMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=i+sUGErn/FnxU1qsgEqhIq2bROwYZJF5vEhCGyQmPo1cG/BIZUT1EVgY15fyiKp3jp
         SXswxGX+VwcHct2dFOUeIlJE8DSuYZPZzTSbTRoAsc9J10Ttc6ld4KZ/sC80sntsdGch
         M99sMR6Y2Dsh31c1c7+Z7DcUGdMY6c8hwuM/0=
Message-ID: <495E045E.5080701@gmail.com>
Date: Fri, 02 Jan 2009 13:11:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: tim@cyberelk.net
Subject: [PATCH?] paride/pg.c: xs(): &&/|| confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

&&/|| confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
to Tim: If you can no longer maintain, you may want to remove your
listing in the maintainers file. 
Can anyone else test this on hardware?

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 9dfa271..c397b3d 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -422,7 +422,7 @@ static void xs(char *buf, char *targ, int len)
 
 	for (k = 0; k < len; k++) {
 		char c = *buf++;
-		if (c != ' ' || c != l)
+		if (c != ' ' && c != l)
 			l = *targ++ = c;
 	}
 	if (l == ' ')
