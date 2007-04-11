Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXDKDj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXDKDj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030758AbXDKDj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:39:26 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15843 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030360AbXDKDjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=UILKaGmGx0jvK6i64pD1GUdUMU7jVS7dPYDzN1FEszfm7MAwWaDvI/jHV+PtHSNwRFqhaZqLJnUGac7AbO3KlvRnXwAktDCNOXWL+jBqvVR1S54voGazIgoe+GY53jYOx7GkC4/q5uW19PgePMQ3cwxZi/VcQ2rhAHIyAfSW2PQ=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.41337.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 12/13] xfs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of the newly deprecated memclear_highpage_flush(). 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/xfs/linux-2.6/xfs_lrw.c linux-2.6.21-rc6-mm1-test/fs/xfs/linux-2.6/xfs_lrw.c
--- linux-2.6.21-rc6-mm1/fs/xfs/linux-2.6/xfs_lrw.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/xfs/linux-2.6/xfs_lrw.c	2007-04-09 18:18:23.000000000 -0700
@@ -159,7 +159,7 @@ xfs_iozero(
 		if (status)
 			goto unlock;
 
-		memclear_highpage_flush(page, offset, bytes);
+		zero_user_page(page, offset, bytes);
 
 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
