Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXHWXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXHWXtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXHWXtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:49:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:59811 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969AbXHWXti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=kqo7E2JRhlhu1ZLrnpE5GaFc+4eY7tbpfnqS3oXcZW0MgFpo3GA5W+3AsYZcKG7p46T77JP3LPbgpr3dHnW1Vj7OyjIyx8ThizKEtfPrSPGE+nWAwSOnJOvCyJSjf053gjR9jE5HEHY9kgvhVolGJRADe+Re/10LAS5LxfrxxgU=
Message-Id: <7cb76a8a31ce41deedace90cd1edd4e0a2c560f9.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:46:43 +0200
Subject: [PATCH 05/30] atm: No need to cast vmalloc() return value
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns void*, no need to cast it in drivers/atm/lanai.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/atm/lanai.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 144a49f..59e7dde 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1459,7 +1459,7 @@ static int __devinit vcc_table_allocate(struct lanai_dev *lanai)
 	return (lanai->vccs == NULL) ? -ENOMEM : 0;
 #else
 	int bytes = (lanai->num_vci) * sizeof(struct lanai_vcc *);
-	lanai->vccs = (struct lanai_vcc **) vmalloc(bytes);
+	lanai->vccs = vmalloc(bytes);
 	if (unlikely(lanai->vccs == NULL))
 		return -ENOMEM;
 	memset(lanai->vccs, 0, bytes);
-- 
1.5.2.2

