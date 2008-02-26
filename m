Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYBZFRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYBZFRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYBZFQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:16:51 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42098 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbYBZFQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:16:50 -0500
X-Sasl-enc: mtK3PvLqk6nE40hhOgqAtBkwLY0DnKYAvEsAbkQwx0vE 1204003008
Date: Tue, 26 Feb 2008 14:14:11 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
 - correction
In-Reply-To: <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0802261410110.15583@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
 <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Ian Kent wrote:
> +
> +		/* Set mount requestor */
> +		if (ino) {
> +			if (ino) {
> +				ino->uid = wq->uid;
> +				ino->gid = wq->gid;
> +			}
> +		}
> +

As has been spotted, this is obviously wrong.
And here is the correction.

Signed-off-by: Ian Kent <raven@themaw.net>

Ian

---
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids-fix linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.track-last-mount-ids-fix	2008-02-26 14:02:05.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-26 14:02:20.000000000 +0900
@@ -385,10 +385,8 @@ int autofs4_wait(struct autofs_sb_info *
 
 		/* Set mount requestor */
 		if (ino) {
-			if (ino) {
-				ino->uid = wq->uid;
-				ino->gid = wq->gid;
-			}
+			ino->uid = wq->uid;
+			ino->gid = wq->gid;
 		}
 
 		if (de)
