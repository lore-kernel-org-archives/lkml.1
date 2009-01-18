Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZARTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZARTKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZARTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:10:28 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:47032 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZARTK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KnbPwvrM3rqJN523Guaqsch2m/Md981eQnMDrbj+Icgo5d9gUY8pVT9I3xOtSjq5pl
         MkG2wbIFKJ2+GoVJWCquHoMDEMjDUVq4FMzZSRJBqt4C11dLThpFPQynCh/5Spi7s9vk
         5XLhUZ3cQgl2ZG/75hv+D5Qlq9Qf1NaM9GV+Q=
Message-ID: <49737EA1.3080805@gmail.com>
Date: Sun, 18 Jan 2009 20:10:25 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>, rminnich@sandia.gov,
       lucho@ionkov.net
CC: v9fs-developer@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/9p: fid->fid is used uninitialized
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I appear to have introduced this myself trying to fix a
signed/unsigned issue, sorry.
---
fid->fid is used uninitialized

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/net/9p/client.c b/net/9p/client.c
index 821f1ec..1eb580c 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -618,7 +618,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 		return ERR_PTR(-ENOMEM);
 
 	ret = p9_idpool_get(clnt->fidpool);
-	if (fid->fid < 0) {
+	if (ret < 0) {
 		ret = -ENOSPC;
 		goto error;
 	}
