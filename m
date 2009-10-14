Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbZJNDCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbZJNDCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZJNDCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:02:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbZJNDCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:02:46 -0400
Date: Tue, 13 Oct 2009 20:01:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] edac: Create an unique instance for each kobj
Message-Id: <20091013200117.895885a6.akpm@linux-foundation.org>
In-Reply-To: <20091004164354.5ff55ea1@pedra.chehab.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
	<20091004164354.5ff55ea1@pedra.chehab.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Oct 2009 16:43:54 -0300 Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Current code only works when there's just one memory
> controller, since we need one kobj for each instance.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/edac_core.h     |   21 ++++++++---
>  drivers/edac/edac_mc_sysfs.c |   75 +++++++++++++++++++++++++++--------------
>  2 files changed, 64 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index d035ee9..f84da6e 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -341,23 +341,29 @@ struct csrow_info {
>  };
>  
>  struct mcidev_sysfs_group {
> -	const char *name;
> -	struct mcidev_sysfs_attribute *mcidev_attr;
> -	struct kobject kobj;
> +	const char *name;				/* group name */
> +	struct mcidev_sysfs_attribute *mcidev_attr;	/* group attributes */
> +};
> +
> +struct mcidev_sysfs_group_kobj {
> +	struct list_head list;		/* list for all instances within a mc */
> +
> +	struct kobject kobj;		/* kobj for the group */
>  
> +	struct mcidev_sysfs_group *grp;	/* group description table */
>  	struct mem_ctl_info *mci;	/* the parent */
>  };

I don't know which kernel you're patching here, but it doesn't look
anything like mine...
