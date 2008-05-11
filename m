Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYEKUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYEKUCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbYEKUCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:02:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:46558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYEKUB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ccTPDVDHqzlfoxc1gpEKIS+6J+kLpN71hVjY2tp/JWEl2isL3WD1UJUwpyDQ3XxmMujK54O6sLYqrmYe1SduPCg1/H8GNjWAlS+cilwRN1WH3dPXujo074XWbFbH1I8iLorAzPqfUvqOHvPbpEzsjvZ6ZBvab5pxPKtjyMegLds=
Date: Sun, 11 May 2008 22:01:29 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [RFC] [PATCH] dlm: tcp_connect_to_sock should check for -EINVAL,
	not EINVAL
Message-ID: <20080511200125.GI19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
it's probably a typo, but I'm not sure
please check if it's the right fix (maybe this condition should be dropped?)
(compile tested only)
---
 fs/dlm/lowcomms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -930,7 +930,7 @@ out_err:
 	 * errors we try again until the max number of retries is reached.
 	 */
 	if (result != -EHOSTUNREACH && result != -ENETUNREACH &&
-	    result != -ENETDOWN && result != EINVAL
+	    result != -ENETDOWN && result != -EINVAL
 	    && result != -EPROTONOSUPPORT) {
 		lowcomms_connect_sock(con);
 		result = 0;
-- 
