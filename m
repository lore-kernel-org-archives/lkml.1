Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0CGD0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 22:26:18 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:61246 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0CGD0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 22:26:17 -0500
Message-ID: <4B931C96.7070703@oracle.com>
Date: Sat, 06 Mar 2010 19:25:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org, david@fromorbit.com
Subject: Re: UML XFS link error list_sort
References: <alpine.DEB.2.00.1003062118240.19862@parag-laptop>
In-Reply-To: <alpine.DEB.2.00.1003062118240.19862@parag-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B931CCB.0079:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> Hi Dave
> 
> While building today's git for CONFIG_UML, I got a link error (list_sort 
> undefined) for xfs.ko.
> 
> Currently I am working around it with the below hack. Not sure the right 
> thing to do would be some where at the arch level for UML or if the below 
> would be appropriate.
> 
> Parag
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index b4769e4..2905cda 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -94,6 +94,8 @@ xfs-y				+= xfs_alloc.o \
>  
>  xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
>  
> +xfs-$(CONFIG_UML)		+= ../../lib/list_sort.o
> +
>  # Objects in linux/
>  xfs-y				+= $(addprefix $(XFS_LINUX)/, \
>  				   kmem.o \
> --

I posted a patch for xfs to select LIST_SORT (kconfig symbol)
so that the library is built for it (xfs).

