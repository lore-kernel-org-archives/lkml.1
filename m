Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYI3MRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYI3MRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI3MRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:17:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55341 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYI3MRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:17:16 -0400
X-AuditID: 0ac90648-a8f1bba000004214-ab-48e218caa7a1
Message-ID: <48E218C0.2030905@hitachi.com>
Date: Tue, 30 Sep 2008 21:17:04 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 1/2] coredump_filter: add hugepage dumping v3
References: <20080925204323.69E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080925204323.69E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

KOSAKI Motohiro wrote:
> Index: b/Documentation/filesystems/proc.txt
> ===================================================================
> --- a/Documentation/filesystems/proc.txt	2008-09-25 21:19:13.000000000 +0900
> +++ b/Documentation/filesystems/proc.txt	2008-09-25 21:21:05.000000000 +0900
> @@ -2408,24 +2408,29 @@ will be dumped when the <pid> process is
>  of memory types. If a bit of the bitmask is set, memory segments of the
>  corresponding memory type are dumped, otherwise they are not dumped.
>  
> -The following 4 memory types are supported:
> +The following 7 memory types are supported:
>    - (bit 0) anonymous private memory
>    - (bit 1) anonymous shared memory
>    - (bit 2) file-backed private memory
>    - (bit 3) file-backed shared memory
>    - (bit 4) ELF header pages in file-backed private memory areas (it is
>              effective only if the bit 2 is cleared)
> +  - (bit 5) hugetlb private memory
> +  - (bit 6) hugetlb shared memory
>  
>    Note that MMIO pages such as frame buffer are never dumped and vDSO pages
>    are always dumped regardless of the bitmask status.
>  
> -Default value of coredump_filter is 0x3; this means all anonymous memory
> -segments are dumped.
> +  Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
> +  effected by bit 5-6.
> +
> +Default value of coredump_filter is 0x23; this means all anonymous memory
> +segments and hugetlb private memory are dumped.
>  
>  If you don't want to dump all shared memory segments attached to pid 1234,
> -write 1 to the process's proc file.
> +write 21 to the process's proc file.

This should be:
write 0x21 to the process's proc file.

Except for this, it seems OK.  Thanks.

Reviewed-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
  
> -  $ echo 0x1 > /proc/1234/coredump_filter
> +  $ echo 0x21 > /proc/1234/coredump_filter
>  
>  When a new process is created, the process inherits the bitmask status from its
>  parent. It is useful to set up coredump_filter before the program runs.

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

