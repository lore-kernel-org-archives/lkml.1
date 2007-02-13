Return-Path: <linux-kernel-owner+w=401wt.eu-S1751189AbXBMIig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbXBMIig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXBMIig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:38:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:6583 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbXBMIif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=XklE51mV3aeVFVqtkJ1CTfWuAGRQfW2dRmDs+6uMnd+58cL3mgQrSEP41FE3DK4jbL2R6hNFnO5ey05qWyb6md5y06AuolTF5JlSiERVx6I8xW/Htiz5BoailuoUtaYXZPia0RhuMb8pYY1pWRE0BFtp+tp8RNYE0ycw0a26bwA=
Date: Tue, 13 Feb 2007 16:38:22 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Andi Kleen <ak@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] nanosecond filesystem support???
Message-ID: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/12/07, Andi Kleen <ak@suse.de> wrote:

> The bigger problem is getting a file system that support it.


Andi,

It seems that the part that's not returning nanosecond is in the code 
below. I've modified it, and now stat() is returning st_mtim.tv_nsec 
correctly.

I've tested it on ext2 and reiserfs, and both seems to be working.


I don't know why "t.tv_nsec = 0;" was set in the code. Any idea?



Thanks,
Jeff.


--- linux/kernel/time.c.org	2007-02-13 08:43:08 +0800
+++ linux/kernel/time.c	2007-02-13 08:52:29 +0800
@@ -86,7 +86,6 @@
  	if (get_user(tv.tv_sec, tptr))
  		return -EFAULT;

-	tv.tv_nsec = 0;

  	err = security_settime(&tv, NULL);
  	if (err)
@@ -269,7 +269,6 @@
  	if (gran <= jiffies_to_usecs(1) * 1000) {
  		/* nothing */
  	} else if (gran == 1000000000) {
-		t.tv_nsec = 0;
  	} else {
  		t.tv_nsec -= t.tv_nsec % gran;
  	}

