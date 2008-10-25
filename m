Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYJYKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYJYKjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYJYKjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:39:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44398 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJYKjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:39:06 -0400
Message-ID: <4902F710.3020100@redhat.com>
Date: Sat, 25 Oct 2008 06:38:08 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
Subject: Re: Bloatwatch 2.6.28-rc1: last_sysfs_file
References: <1224881514.3248.46.camel@calx> <1224882923.3248.51.camel@calx>
In-Reply-To: <1224882923.3248.51.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, 2008-10-24 at 15:52 -0500, Matt Mackall wrote:
>> 2.6.28-rc1 adds 4k for last_sysfs_file debug tracking. That's one hell
>> of a long sysfs path.
>>
>> http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/fs/sysfs
> 
> ..especially given that printk is limited to 1k at a time.
> 
> 
> sysfs: shrink last_sysfs_file to a reasonable size
> 
> sysfs was reserving 4k to store filenames for debug despite printk being
> limited to 1k. Shrink this to something more reasonable.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r ac8c82ff3be7 fs/sysfs/file.c
> --- a/fs/sysfs/file.c	Fri Oct 24 13:13:04 2008 -0500
> +++ b/fs/sysfs/file.c	Fri Oct 24 16:11:53 2008 -0500
> @@ -25,7 +25,7 @@
>  #include "sysfs.h"
>  
>  /* used in crash dumps to help with debugging */
> -static char last_sysfs_file[PATH_MAX];
> +static char last_sysfs_file[200]; /* allow for disgustingly long paths */
>  void sysfs_printk_last_file(void)
>  {
>  	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> 
> 

Please don't use magic numbers.  Use a symbolic constant, and modify printk.c to 
use the same.  If we're going to impose limits lower than the maximum, let's at 
least be consistent about it.

-- Chris
