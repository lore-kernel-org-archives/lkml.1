Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZJ2QSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZJ2QSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZJ2QSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:18:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZJ2QSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:18:47 -0400
Message-ID: <4AE9C0B0.3030304@suse.de>
Date: Thu, 29 Oct 2009 17:20:00 +0100
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated dynamically
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org>
In-Reply-To: <20091020055021.GE29158@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index af4c4e7..13843fa 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -17,6 +17,9 @@ struct sysfs_elem_dir {
>  	struct kobject		*kobj;
>  	/* children list starts here and goes through sd->s_sibling */
>  	struct sysfs_dirent	*children;
> +	int (*populate)(struct dentry *, struct sysfs_dirent *);
> +	void (*depopulate)(struct dentry *, struct sysfs_dirent *);
> +	void *data;

This will increase the size of struct sysfs_dirent by three pointers
which is considerable.  Bloating the size of sysfs_dirent can waste
large amount of memory on machines with a lot of disks.

The implementation looks quite scary to me.  Is this the only way to
do this?  It it because trying to create individual entries for msix
will end up creating too many sysfs entries?  If so, how many are we
talking about?

Thanks.

-- 
tejun
