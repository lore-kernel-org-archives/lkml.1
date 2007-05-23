Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXEWC7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXEWC7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXEWC7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:59:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:20100 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbXEWC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GIHdLr4h4462DMIXHJTk2ORemngBYvG9mredpYjtumqFKbcV+LH/bD1clkyQRjeAIgymEbmiNKn2+ss0aaNuhGc3NizT9lDViYqgu/4X2dfHrTmQyvK0ecwaEn+5i74kptOSU0oCZ1NuWAQCylQmp3vYL4psF4PFpBmnnuv/Shw=
Message-ID: <a8e1da0705221959i7b01deb7vdd641ef0ed31e63e@mail.gmail.com>
Date: Wed, 23 May 2007 02:59:07 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Steven French" <sfrench@us.ibm.com>
In-Reply-To: <20070522192231.6d1a94df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705221750y6f4fb251m53f3efab1f017f4@mail.gmail.com>
	 <20070522192231.6d1a94df.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
maybe we can add if sentence before kthread_stop.

diff -ur linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
--- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
+++ linux.new/fs/cifs/connect.c 2007-05-23 10:58:39.000000000 +0000
@@ -2070,7 +2070,8 @@
                        spin_unlock(&GlobalMid_Lock);
                        if (srvTcp->tsk) {
                                send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
+                               if(srvTcp->tsk)
+                                       kthread_stop(srvTcp->tsk);
                        }
                }


Regards
dave
