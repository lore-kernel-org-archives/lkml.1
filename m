Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXFKFNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXFKFNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXFKFNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:13:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:54112 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFKFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O6+S4SpsJTN5dqGGXMpJ63hoBETz/LRuFEveYQzPJYNyWPpryxPDirQJvQn/NV4pLU3q4bWbQCYwWn8ej1elMcQc+SarzyjHuZprt7gItLzFfK1p0gULaQSQ+E7CJ00kmnpsotKYFaaxRaDnlf2/NpFbCAPnryBqGdKJ435Z/gU=
Date: Mon, 11 Jun 2007 14:03:27 +0900
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       cebbert@redhat.com, sandeen@redhat.com, maneesh@in.ibm.com,
       cs@tequila.co.jp
Subject: [PATCH 2/3] sysfs: fix condition check in sysfs_drop_dentry()
Message-ID: <20070611050327.GL29122@htj.dyndns.org>
References: <20070611050107.GJ29122@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611050107.GJ29122@htj.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The condition check doesn't make much sense as it basically always
succeeds.  This causes NULL dereferencing on certain cases.  It seems
that parentheses are put in the wrong place.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work1/fs/sysfs/inode.c
===================================================================
--- work1.orig/fs/sysfs/inode.c
+++ work1/fs/sysfs/inode.c
@@ -252,7 +252,7 @@ void sysfs_drop_dentry(struct sysfs_dire
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
-		if (!(d_unhashed(dentry) && dentry->d_inode)) {
+		if (!d_unhashed(dentry) && dentry->d_inode) {
 			inode = dentry->d_inode;
 			spin_lock(&inode->i_lock);
 			__iget(inode);
