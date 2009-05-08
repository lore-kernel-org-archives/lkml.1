Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbZEHTEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbZEHTEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZEHTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:04:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbZEHTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:04:07 -0400
Date: Fri, 8 May 2009 12:01:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone
 over NFS
Message-Id: <20090508120119.8c93cfd7.akpm@linux-foundation.org>
In-Reply-To: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 10:01:58 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> I've been working on CFQ improvements for interleaved I/Os between
> processes, and noticed a regression in performance when using the
> deadline I/O scheduler.  The test uses a server configured with a cciss
> array and 1Gb/s ethernet.
> 
> The iozone command line was:
>   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
> 
> The numbers in the nfsd's row represent the number of nfsd "threads".
> These numbers (in MB/s) represent the average of 5 runs.
> 
>                v2.6.29
> 
> nfsd's  |   1    |  2   |   4   |   8
> --------+---------------+-------+------
> deadline| 43207 | 67436 | 96289 | 107590
> 
>               2.6.30-rc1
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> deadline| 43732 | 68059 | 76659 | 83231
> 
>     2.6.30-rc3.block-for-linus
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> deadline| 46102 | 71151 | 83120 | 82330
> 
> 
> Notice the drop for 4 and 8 threads.  It may be worth noting that the
> default number of NFSD threads is 8.
> 

I guess we should ask Rafael to add this to the post-2.6.29 regression
list.

