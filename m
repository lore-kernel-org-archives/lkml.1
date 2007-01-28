Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXA1HIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXA1HIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 02:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXA1HIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 02:08:43 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:36805 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbXA1HIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 02:08:42 -0500
Message-ID: <45BC4BEF.3040303@linux.vnet.ibm.com>
Date: Sun, 28 Jan 2007 12:38:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drop page cache of a single file
References: <1167275845.15989.153.camel@ymzhang>
In-Reply-To: <1167275845.15989.153.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Zhang, Yanmin wrote:
> Currently, by /proc/sys/vm/drop_caches, applications could drop pagecache,
> slab(dentries and inodes), or both, but applications couldn't choose to
> just drop the page cache of one file. An user of VOD (Video-On-Demand)
> needs this capability to have more detailed control on page cache release.
> 
> Below patch against 2.6.19 implements it.
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> ---
> 
> diff -Nraup linux-2.6.19/Documentation/filesystems/proc.txt linux-2.6.19_dropcache/Documentation/filesystems/proc.txt
> --- linux-2.6.19/Documentation/filesystems/proc.txt	2006-12-08 15:32:44.000000000 +0800
> +++ linux-2.6.19_dropcache/Documentation/filesystems/proc.txt	2006-12-28 10:20:39.000000000 +0800
> @@ -1320,6 +1320,8 @@ To free dentries and inodes:
>  	echo 2 > /proc/sys/vm/drop_caches
>  To free pagecache, dentries and inodes:
>  	echo 3 > /proc/sys/vm/drop_caches
> +To free the pagecache of one file:
> +	echo "4 /path/to/filename" > /proc/sys/vm/drop_caches
> 
>  As this is a non-destructive operation and dirty objects are not freeable, the
>  user should run `sync' first.

"sync" is the most time consuming operation.  Clean pagecache pages
are immediately reclaimable... they are actually free pages.  Writing
out dirty pages consumes time.

Hence this approach may not provide the required performance benefits
since only clean pagecache pages are marked free.  fadvise approach
would provide similar behavior.

--Vaidy

[snip]

