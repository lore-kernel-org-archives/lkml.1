Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYATQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYATQxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYATQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:53:13 -0500
Received: from mail.vyatta.com ([216.93.170.194]:34328 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYATQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:53:12 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.599
Date: Sun, 20 Jan 2008 08:50:08 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Clark <michael@metaparadigm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hi-res mtime userspace interface
Message-ID: <20080120085008.5c0e2b64@deepthought>
In-Reply-To: <47934820.7020209@metaparadigm.com>
References: <47934820.7020209@metaparadigm.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2008 21:09:52 +0800
Michael Clark <michael@metaparadigm.com> wrote:

> Is there an existing linux userspace interface for accessing the 
> microsecond or nanosecond level (a|m|c)times of filesystems that support 
> them (e.g. ext4, xfs)? and possibly also the generation counters used by 
> NFS.
> 
> I notice sys_utimes is able to set microsecond (c|a|m)times but I can't 
> find an associated interface to read them (I've googled to no avail).
> 
> (also noticing freebsd and darwin's struct stat contains struct timespec 
> for these as well as an st_gen field - although I do realise how 
> incredibly difficult it would be to add these to linux's struct stat).
> 

Look at stat.

In /usr/include/bits/stat.h:
struct stat
  {
    __dev_t st_dev;		/* Device.  */
...
#ifdef __USE_MISC
    /* Nanosecond resolution timestamps are stored in a format
       equivalent to 'struct timespec'.  This is the type used
       whenever possible but the Unix namespace rules do not allow the
       identifier 'timespec' to appear in the <sys/stat.h> header.
       Therefore we have to handle the use of this header in strictly
       standard-compliant sources special.  */
    struct timespec st_atim;		/* Time of last access.  */
    struct timespec st_mtim;		/* Time of last modification.  */
    struct timespec st_ctim;		/* Time of last status change.  */
# define st_atime st_atim.tv_sec	/* Backward compatibility.  */
# define st_mtime st_mtim.tv_sec
# define st_ctime st_ctim.tv_sec
#else
    __time_t st_atime;			/* Time of last access.  */
    unsigned long int st_atimensec;	/* Nscecs of last access.  */
    __time_t st_mtime;			/* Time of last modification.  */
    unsigned long int st_mtimensec;	/* Nsecs of last modification.  */
    __time_t st_ctime;			/* Time of last status change.  */
    unsigned long int st_ctimensec;	/* Nsecs of last status change.  */
#endif
-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
