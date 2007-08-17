Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXHQTNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXHQTNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXHQTNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:13:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61424 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbXHQTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ogtTxzaEhEEPQIt+d9aRrHkirkmIQchTtVEvKp665l9e6x3QXpac8oFeKRQuetjxoLJqgwiykez7RZutBq9yqGKnJ5gvRA5uP9BHa04eQxOXKDQd6CeTmVCEcvKk8D55TDMCrQxsVrLAwYX/357EO93Yr1XNjuJgwqDtKMA/Y0k=
Date: Fri, 17 Aug 2007 23:13:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] CIFS: check for granted memory
Message-ID: <20070817191329.GA7218@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds just a check for granted memory
to prevent possible NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 fs/cifs/sess.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2ea027d..892be9b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -372,6 +372,10 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses, int first_time,
 
 	/* 2000 big enough to fit max user, domain, NOS name etc. */
 	str_area = kmalloc(2000, GFP_KERNEL);
+	if (str_area == NULL) {
+		cifs_small_buf_release(smb_buf);
+		return -ENOMEM;
+	}
 	bcc_ptr = str_area;
 
 	ses->flags &= ~CIFS_SES_LANMAN;
