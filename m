Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZKKVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZKKVdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbZKKVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:33:09 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:34943 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758874AbZKKVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=KBqetx73Nqw4yEis2wZxZVjRFzRY0tG/WiLan+LERKgSVQediKHTuI7QCJ+f7hsjRY
         7dDawUJc7niEj/8amuEkDIAIqP9G94/zkmgyqRJNwl+lf5wcbDbtbdxAs2LxTBzTDjyq
         H5O9mc4gDuZEnMDxDypXrlvENVeF3Mp8B/CwY=
Message-ID: <4AFB3066.4080102@gmail.com>
Date: Wed, 11 Nov 2009 22:45:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mfasheh@suse.com,
       joel.becker@oracle.com, ocfs2-devel@oss.oracle.com
Subject: [PATCH] ocfs2: Should error return be negative?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

The return of a positive error is unusual for oracle:

[roel@zoinx linux-git]$ git grep -n -E "return E[[:upper:]]*;" -- fs/ocfs2/ | wc -l
1
[roel@zoinx linux-git]$ git grep -n -E "return -E[[:upper:]]*;" -- fs/ocfs2/ | wc -l
251

is this maybe required?

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d9fa3d2..0a8a6a4 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2639,7 +2639,7 @@ int dlm_begin_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
-		return EAGAIN;
+		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
 
