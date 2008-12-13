Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYLMVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYLMVtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 16:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYLMVtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 16:49:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:33740 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYLMVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 16:49:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hItNp2lfSh4BDQ6RcUWnXFMTT7whVPp1Gy2TBoILBpt/+1QRnpi3VsqNtUHQxo0gAE
         V162gsl0v74Dqql1e1VCt7pA2Q1sfudRpY1P8b14V2VfNwqOuTDK5gg+8TL35q5eAPAH
         rSQFKauRmtUwW1uKSHsgySn9TocZXTWOKhQP0=
Date: Sun, 14 Dec 2008 00:49:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs - fix name overwrite in __register_chrdev_region
Message-ID: <20081213214911.GI16354@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to register chdev with a name size
exactly the same as was allocated in structure.
It seems it was not intedned behaviour.

At least chrdev_show does not like it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 fs/char_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/fs/char_dev.c
===================================================================
--- linux-2.6.git.orig/fs/char_dev.c
+++ linux-2.6.git/fs/char_dev.c
@@ -120,7 +120,7 @@ __register_chrdev_region(unsigned int ma
 	cd->major = major;
 	cd->baseminor = baseminor;
 	cd->minorct = minorct;
-	strncpy(cd->name,name, 64);
+	strncpy(cd->name, name, sizeof(cd->name) - 1);
 
 	i = major_to_index(major);
 
