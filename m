Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXF0GbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXF0GbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbXF0Ga5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:30:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59907 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760075AbXF0Ga4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:30:56 -0400
Date: Wed, 27 Jun 2007 12:08:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: menage@google.com, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for bad lock balance in Containers
Message-ID: <20070627063815.GA3488@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070626050011.GA12584@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626050011.GA12584@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 10:30:11AM +0530, Dhaval Giani wrote:
> 
> --- linux-2.6.22-rc4/kernel/container.c	2007-06-13 15:38:32.000000000 +0530
> +++ old/kernel/container.c	2007-06-25 00:55:03.000000000 +0530
> @@ -995,6 +995,7 @@ static int container_get_sb(struct file_
>  		BUG_ON(ret);
>  	} else {
>  		/* Reuse the existing superblock */
> +		down_write(&(root->sb->umount));
>  		ret = simple_set_mnt(mnt, root->sb);
>  		if (!ret)
>  			atomic_inc(&root->sb->s_active);

Do you want to change this to first take refererence on sb and then
do simple_set_mnt() ?

And btw, simple_set_mnt() always returns zero and looks like it can't fail.

Regards,
Bharata.
