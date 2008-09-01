Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYIAQmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYIAQmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYIAQmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:42:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:46436 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbYIAQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QNgdoT9zVP7GLd7uZ2fd9SC97cYOTiolCMr5k01NVymJTMw/WfGi7Bl7j3yVsCIibn
         ZUSiCeEaFFsVPum+dNSULEMTl6ZOT20V3xZ1Kz2NBHQ0F9MjmTky6xmTpDJHslnQc8/q
         ghfap3tOjRnJn56SLtyVGUGfss0D5idZntNV0=
Date: Mon, 1 Sep 2008 20:43:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: proc: remove dummy vmcore_open()
Message-ID: <20080901164354.GC24546@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty ->open is equvivalent to always succeeding ->open.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/vmcore.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -165,14 +165,8 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	return acc;
 }
 
-static int open_vmcore(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
 const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
-	.open		= open_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)

