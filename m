Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbXE2SEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbXE2SEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXE2SER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:04:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3883 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbXE2SEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O+GsJvuSM034Z/SThatvbu+RvxjYRU6oUtI240Txs6ywxwCO2I8rxabxhTidiSOF6pf8tLLpgj+STPceOtxaOBaGnI2qeCCqLL6AzobY4AaO73YNfeEiYFHGaytcrig3uR6wkNC3CpnYQWBKtwWQ07a/IbnrwJN9G5zZg31B4oM=
Date: Tue, 29 May 2007 22:04:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] FILESYSTEMS:  Delete unused "int dummy[5]" from inodes_stat_t.
Message-ID: <20070529180422.GA5666@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:11:07PM -0400, Robert P. J. Day wrote:
> Delete the apparently unused array "int dummy[5]" from struct
> inodes_stat_t.

>   no idea what that array is for, but no one seems to care about it.
> removal compile-tested on x86 with "make allyesconfig" and nobody
> misses it (unless it's used for padding of some kind).

> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -44,7 +44,6 @@ extern int get_max_files(void);
>  struct inodes_stat_t {
>  	int nr_inodes;
>  	int nr_unused;
> -	int dummy[5];
>  };
>  extern struct inodes_stat_t inodes_stat;

Please...

static ctl_table fs_table[] = {
	{
		.ctl_name	= FS_NRINODE,
		.procname	= "inode-nr",
		.data		= &inodes_stat,
		.maxlen		= 2*sizeof(int),
		.mode		= 0444,
		.proc_handler	= &proc_dointvec,
	},
	{
		.ctl_name	= FS_STATINODE,
		.procname	= "inode-state",
		.data		= &inodes_stat,
		.maxlen		= 7*sizeof(int),
				 ^^^

