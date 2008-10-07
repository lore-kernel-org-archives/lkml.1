Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYJGTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYJGTU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYJGTUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:20:17 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64518 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYJGTUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:cc:x-mailer;
        b=tW2n2mxxsSAnmEtsDKgj969IiIAwAyVI3DfmEls8bVtvkCGCMY8QOKSiJqWUXvQoKK
         8unapPQebk91jhxdXZzus9UzmdIPdvo25UIa8lOyAkLj4eCAEqwOrFKT3LXLAjZsjVQg
         yGqGQC+KRKApJzIpVbFPWyCom3xFcnnHe72Qs=
Message-Id: <67AA922F-881E-47F1-866B-9613E30C7A78@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: [PATCH] phonedev: remove BKL
Date: Tue, 7 Oct 2008 13:20:11 -0600
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the BKL from the phonedev module. The phone_device  
array is covered by the phone_lock mutex in all cases and  
request_module no longer needs the BKL so we can remove the only  
remaining instance of the BKL from phonedev.

Signed-off-by: Richard Holden <aciddeath@gmail.com>

diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 4d74ba3..37caf4d 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -54,7 +54,6 @@ static int phone_open(struct inode *inode, struct  
file *file)
  	if (minor >= PHONE_NUM_DEVICES)
  		return -ENODEV;

-	lock_kernel();
  	mutex_lock(&phone_lock);
  	p = phone_device[minor];
  	if (p)
@@ -81,7 +80,6 @@ static int phone_open(struct inode *inode, struct  
file *file)
  	fops_put(old_fops);
  end:
  	mutex_unlock(&phone_lock);
-	unlock_kernel();
  	return err;
  }

