Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbXF0HiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbXF0HiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXF0HiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:38:17 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58890 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbXF0HiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:38:16 -0400
Date: Wed, 27 Jun 2007 13:04:55 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Fix for bad lock balance in Containers
Message-ID: <20070627073455.GB17922@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070626050011.GA12584@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626050011.GA12584@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:30:11AM +0530, Dhaval Giani wrote:
Hi,

There was a mistake in the patch. Thanks to Andrew Morton for pointing it out.
Sending out a fresh patch. Sorry for the mistake!
 
>  		BUG_ON(ret);
>  	} else {
>  		/* Reuse the existing superblock */
> +		down_write(&(root->sb->umount));

Should be down_write(&(root->sb->s_umount));

>  		ret = simple_set_mnt(mnt, root->sb);
>  		if (!ret)
>  			atomic_inc(&root->sb->s_active);

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


--- linux-2.6.22-rc4/kernel/container.c	2007-06-13 15:38:32.000000000 +0530
+++ old/kernel/container.c	2007-06-25 00:55:03.000000000 +0530
@@ -995,6 +995,7 @@ static int container_get_sb(struct file_
 		BUG_ON(ret);
 	} else {
 		/* Reuse the existing superblock */
+		down_write(&(root->sb->s_umount));
 		ret = simple_set_mnt(mnt, root->sb);
 		if (!ret)
 			atomic_inc(&root->sb->s_active);
