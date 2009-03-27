Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbZC0Kbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbZC0Kbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbZC0Kbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:31:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbZC0Kbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=VnSlf+UGvHXUkvf9gJOSp8nUmS0pFcXpBZCP9CkoC9GcqAIZCOhfL1sQRlrMbr/ByL
         81vOHRKsOXObnS9cTwDCY3sOYS5YHQctMy9oN6p/kh9q4OS+7JCK+CO1seNif3aG362V
         +3qT4j5skqw+eAaR8EqLjSSgnLjMdLG+/Old8=
Date: Fri, 27 Mar 2009 13:28:48 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@usbsys.site
To: linux-kernel@vger.kernel.org
cc: eteo@redhat.com
Subject: [patch] char/raw.c locking on error
Message-ID: <Pine.LNX.4.64.0903262243150.4167@usbsys.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an unlock_kernel missing.

This bug was found by smatch (http://repo.or.cz/w/smatch.git/).  Compile 
tested only, sorry.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/char/raw.c	2009-03-26 22:40:27.000000000 +0300
+++ devel/drivers/char/raw.c	2009-03-26 22:41:20.000000000 +0300
@@ -90,6 +90,7 @@
 	blkdev_put(bdev, filp->f_mode);
 out:
 	mutex_unlock(&raw_mutex);
+	unlock_kernel();
 	return err;
 }
 
