Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYATXoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYATXoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 18:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYATXoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 18:44:06 -0500
Received: from metamail-vm.metaparadigm.com ([203.117.131.43]:52669 "EHLO
	metamail-vm.metaparadigm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232AbYATXoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 18:44:05 -0500
Message-ID: <4793DCB1.1090802@metaparadigm.com>
Date: Mon, 21 Jan 2008 07:43:45 +0800
From: Michael Clark <michael@metaparadigm.com>
Organization: Metaparadigm Pte Ltd
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: hi-res mtime userspace interface
References: <47934820.7020209@metaparadigm.com> <20080120085008.5c0e2b64@deepthought>
In-Reply-To: <20080120085008.5c0e2b64@deepthought>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Look at stat.
>   

Thanks. OK that was what I wanted. I hadn't looked further than man 2 
stat - I think the stat man page needs an update.

> In /usr/include/bits/stat.h:
> struct stat
>   {
>     __dev_t st_dev;		/* Device.  */
> ...
> #ifdef __USE_MISC
>     /* Nanosecond resolution timestamps are stored in a format
>        equivalent to 'struct timespec'.  This is the type used
>        whenever possible but the Unix namespace rules do not allow the
>        identifier 'timespec' to appear in the <sys/stat.h> header.
>        Therefore we have to handle the use of this header in strictly
>        standard-compliant sources special.  */
>     struct timespec st_atim;		/* Time of last access.  */
>     struct timespec st_mtim;		/* Time of last modification.  */
>     struct timespec st_ctim;		/* Time of last status change.  */
> # define st_atime st_atim.tv_sec	/* Backward compatibility.  */
> # define st_mtime st_mtim.tv_sec
> # define st_ctime st_ctim.tv_sec
> #else
>     __time_t st_atime;			/* Time of last access.  */
>     unsigned long int st_atimensec;	/* Nscecs of last access.  */
>     __time_t st_mtime;			/* Time of last modification.  */
>     unsigned long int st_mtimensec;	/* Nsecs of last modification.  */
>     __time_t st_ctime;			/* Time of last status change.  */
>     unsigned long int st_ctimensec;	/* Nsecs of last status change.  */
> #endif
>   

