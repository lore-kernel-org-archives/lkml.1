Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbXHHOfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbXHHOfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHHOfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:35:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:42185 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXHHOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=VeI4t4rtO3ztpFCrZNIPXYoreXVsxD0I1O28IBQHkOgK4x+U1OFyiTpf6ulT3cq4lbfVNet5HwvosmHfc8VzNPjyob6jtpQ7JXY2Rek2TYO00fY/JptrRvIivlUFIyF7i5ziwoVPWKdnfNsoYMW7wlHTypKZVl8Rac74p8rDCtk=
Message-ID: <46B9D4B8.4050201@gmail.com>
Date: Wed, 08 Aug 2007 23:35:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com> <20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------030003090206010103020901"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030003090206010103020901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Does the attached patch happen to fix the problem?

-- 
tejun

--------------030003090206010103020901
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 fs/sysfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
@@ -1010,7 +1010,7 @@ static int sysfs_readdir(struct file * f
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if ((filp->f_pos > 1) && (filp->f_pos < UINT_MAX)) {
+	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
 		mutex_lock(&sysfs_mutex);
 
 		/* Skip the dentries we have already reported */
@@ -1031,7 +1031,7 @@ static int sysfs_readdir(struct file * f
 				break;
 		}
 		if (!pos)
-			filp->f_pos = UINT_MAX;
+			filp->f_pos = INT_MAX;
 		mutex_unlock(&sysfs_mutex);
 	}
 	return 0;

--------------030003090206010103020901--
