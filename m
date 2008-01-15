Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYAOBKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYAOBKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYAOBK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:10:28 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:50869 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYAOBK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:10:27 -0500
Date: Mon, 14 Jan 2008 17:08:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-Id: <20080114170804.b5961aea.randy.dunlap@oracle.com>
In-Reply-To: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 10:01:21 +0900 KOSAKI Motohiro wrote:

> the core of this patch series.
> add /dev/mem_notify device for notification low memory to user process.
> 
> <usage examle>
> 
>         fd = open("/dev/mem_notify", O_RDONLY);
>         if (fd < 0) {
>                 exit(1);
>         }
>         pollfds.fd = fd;
>         pollfds.events = POLLIN;
>         pollfds.revents = 0;
> 	err = poll(&pollfds, 1, -1); // wake up at low memory
> 
>         ...
> </usage example>
> 
> Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  drivers/char/mem.c         |    6 ++
>  include/linux/mem_notify.h |   41 ++++++++++++++++
>  include/linux/mmzone.h     |    1 
>  mm/Makefile                |    2 
>  mm/mem_notify.c            |  109 +++++++++++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c            |    1 
>  6 files changed, 159 insertions(+), 1 deletion(-)
> 

Hi,

1/ I don't see the file below listed in the diffstat above...

2/ Where is the userspace interface information for the syscall?

> Index: linux-2.6.24-rc6-mm1-memnotify/Documentation/devices.txt
> ===================================================================
> --- linux-2.6.24-rc6-mm1-memnotify.orig/Documentation/devices.txt	2008-01-13 16:42:57.000000000 +0900
> +++ linux-2.6.24-rc6-mm1-memnotify/Documentation/devices.txt	2008-01-13 17:07:05.000000000 +0900
> @@ -96,6 +96,7 @@ Your cooperation is appreciated.
>  		 11 = /dev/kmsg		Writes to this come out as printk's
>  		 12 = /dev/oldmem	Used by crashdump kernels to access
>  					the memory of the kernel that crashed.
> +		 13 = /dev/mem_notify   Low memory notification.
>  
>    1 block	RAM disk
>  		  0 = /dev/ram0		First RAM disk


---
~Randy
