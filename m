Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbXE3L36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbXE3L36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXE3L3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:29:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48895 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbXE3L3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:29:50 -0400
Date: Wed, 30 May 2007 13:29:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] FILESYSTEMS: Delete unused "int dummy[5]" from
	inodes_stat_t.
Message-ID: <20070530112946.GT3899@stusta.de>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain> <20070529110041.49bf57f1.akpm@linux-foundation.org> <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain> <20070529111902.27055fd0.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain> <465C71EA.5040706@oracle.com> <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com> <20070529123326.a8a1bd64.randy.dunlap@oracle.com> <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 08:41:56AM +0200, Stefan Richter wrote:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: fs: clarify "dummy" member in struct inodes_stat_t
> 
> Found by Robert P. J. Day:  The role of inodes_stat_t.dummy wasn't clear
> and one might be tempted to remove it.  Give it a better name and add a
> comment.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> Only quickly compile-tested.
> 
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h
> +++ linux/include/linux/fs.h
> @@ -44,7 +44,7 @@ extern int get_max_files(void);
>  struct inodes_stat_t {
>  	int nr_inodes;
>  	int nr_unused;
> -	int dummy[5];
> +	int reserved[5];	/* for sysctl and procfs ABI compatibility */
>  };
>  extern struct inodes_stat_t inodes_stat;

Considering that we export this struct to usespace, I don't think 
renaming a member without a good reason is a good idea (but adding a 
comment makes sense).

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

