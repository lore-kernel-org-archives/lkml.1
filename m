Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZLGNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZLGNNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZLGNNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:13:23 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50095 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbZLGNNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mjvQBkTX56ej+3th8qk9TXrvoh/Ii9h6hBws/qm5pyvygqEQeRpa0lh8faXCiSI9UA
         5WZpjSDKiAOSoliga579L0ILzBexg+8q8Qn0zv1xJ/eILqCSQKP+t1Qv/M4UA+O9gns+
         A0DQMsEkiohA7fZaHkRzEIS2SDWH6bkM3OI/Y=
Message-ID: <4B1CFFBA.8060407@gmail.com>
Date: Mon, 07 Dec 2009 14:14:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] IB/uverbs: PTR_ERR return of wrong pointer in ib_uverbs_get_context()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/infiniband/core/uverbs_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless this should be fixed otherwise?

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 56feab6..112d397 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -285,7 +285,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 
 	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
 	if (IS_ERR(ucontext)) {
-		ret = PTR_ERR(file->ucontext);
+		ret = PTR_ERR(ucontext);
 		goto err;
 	}
 
