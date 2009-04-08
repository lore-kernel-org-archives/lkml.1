Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbZDHLNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbZDHLNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbZDHLMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:12:50 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:42657 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760949AbZDHLMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=dYKqdZ/CQ1Ggpy7e8DZqQ6d0cHT+ylGOzS2QrcFHNT48ZUrCtCwqugNA96mVFz8lwE
         dWJm6rs7sjIe84F5si2IC4Z5CX9DtHP0jCwEqRNO0MqPhrH46UhboslXVVKK9uZKz6mZ
         qIl9FQoqI1MYtlVKqHg7ntpVwkKwO5lGbRum0=
Date: Wed, 8 Apr 2009 14:09:15 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: [patch] trivial: unreached code. drivers/net/mlx4/en_rx.c
Message-ID: <alpine.DEB.2.00.0904081406130.30705@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the return after the goto.  We want the goto because it frees 
memory as well as returning err.

Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/mlx4/en_rx.c	2009-04-07 21:01:20.000000000 +0300
+++ devel/drivers/net/mlx4/en_rx.c	2009-04-07 21:01:27.000000000 +0300
@@ -950,7 +950,6 @@
 	if (err) {
 		mlx4_err(mdev, "Failed to allocate qp #%d\n", qpn);
 		goto out;
-		return err;
 	}
 	qp->event = mlx4_en_sqp_event;
 
