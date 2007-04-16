Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXDPRxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXDPRxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXDPRxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:53:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57764 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbXDPRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tSXkVHesulJEM09UEtEdFrXH50sLL4tGYtSgGHddg/PNVs30Ph5GWLoDRgCrGZJNhHd3Guo5y+4eKihylniu3e8Fs1s3mq4q1OqwcM7isgyUk+t9mMaW4VqSmT5Sm8xfwX97JnYIp2Bl8Hnlr7K/SknMpwM1BgUYtfPq03LykxQ=
Date: Mon, 16 Apr 2007 23:25:51 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>
Cc: Kernel Newbies <kernelnewbies@nl.linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [KJ]use mutex instead of a binary semaphore
Message-ID: <20070416175551.GB9314@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	As the new mutex primitive is now in place, I read,it is advised 
not to use binary semaphore for mutual exclusion.

while looking at different place where a binary semaphore is initialized,
I came accross bd_mount_sem.

I read a thread on LKML few months back related to the bd_mount_sem 
and realized that there are cases where a binary semaphore  can not be replaced by a mutex.
The reason being mutex has a sense of ownership, i.e. 
a mutex can only be unlocked from the context
 from which it was locked.

e.g bd_mount_sem in the block device structure is 
used to make sure no new mounts happen on bdev
 in between freeze_bdev and thaw_bdev().

so locking is done in freeze_bdev &
 unlocking in thaw_bdev these can be from different context i guess..

is my understandig correct..
CMIIW..
would appreciate some pointers on how to identify such cases.. 


-- 
Milind Arun Choudhary
