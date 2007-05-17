Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXEQRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXEQRxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXEQRxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:53:11 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:19978 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbXEQRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MYcJkpP4dZ09+oJO5gFXy3eWBxRpL26R9W/A7BNBsbEgcEvyDXByL3kinqrNY78zdisPiz8Ua8BgLP3hEID/BRkt/zcdW6SAsBz3fB+v1a+Wtcwm4dTsdlsDgXpUVUCVmGTSZSG3XnGeVjvAUf+dusPqvxCqGGrhFPbVYSEtPFc=
Message-ID: <464C9675.3030101@gmail.com>
Date: Thu, 17 May 2007 19:52:53 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH 1/2] sysfs: fix condition check in sysfs_drop_dentry()
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com>
In-Reply-To: <464C95AB.3020209@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The condition check doesn't make much sense as it basically always
succeeds.  This causes NULL dereferencing on certain cases.  It seems
that parentheses are put in the wrong place.  Fix it.

DON'T APPLY JUST YET
---

Maneesh, is this correct?

 fs/sysfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/fs/sysfs/inode.c
===================================================================
--- work.orig/fs/sysfs/inode.c
+++ work/fs/sysfs/inode.c
@@ -250,7 +250,7 @@ void sysfs_drop_dentry(struct sysfs_dire
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
-		if (!(d_unhashed(dentry) && dentry->d_inode)) {
+		if (!d_unhashed(dentry) && dentry->d_inode) {
 			inode = dentry->d_inode;
 			spin_lock(&inode->i_lock);
 			__iget(inode);
