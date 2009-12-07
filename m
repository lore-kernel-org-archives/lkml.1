Return-Path: <linux-kernel-owner+w=401wt.eu-S935601AbZLGVNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601AbZLGVNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965023AbZLGVNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:13:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37691 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549AbZLGVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:13:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vqLtXd66OZ70ek3f4rwzL/JT3YqoAxp/UNHrFl9U2H5HMBGY5E3+8LXwGCb5lCF+R1
         c22StrdabR4xt6gKI8x3iGl/rNH7e3KFj6po6ppgn1jOl7CQS6d89+C9rC7t0r2Uw97r
         IVx0r7gttdTIQmH9w2gtgsUpY/roVCWImc3eU=
Message-ID: <4B1D702D.3020007@gmail.com>
Date: Mon, 07 Dec 2009 22:14:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, galak@kernel.crashing.org,
       avorontsov@ru.mvista.com
Subject: [PATCH] powerpc/85xx: Wrong variable returned on error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong variable was returned in the case of an error

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/powerpc/platforms/85xx/mpc85xx_mds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 3909d57..ad1609c 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -86,7 +86,7 @@ static int mpc8568_fixup_125_clock(struct phy_device *phydev)
 	scr = phy_read(phydev, MV88E1111_SCR);
 
 	if (scr < 0)
-		return err;
+		return scr;
 
 	err = phy_write(phydev, MV88E1111_SCR, scr | 0x0008);
 
