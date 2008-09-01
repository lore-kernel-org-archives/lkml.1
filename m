Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYIAGAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYIAGAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYIAGAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:00:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39547 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYIAGAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:00:42 -0400
X-AuditID: 0ac90647-aca3eba0000039ee-ff-48bb8508476b
Message-ID: <48BB8501.6070806@hitachi.com>
Date: Mon, 01 Sep 2008 15:00:33 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>, agl@us.ibm.com
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

KOSAKI Motohiro wrote:

> Now, hugepage's vma has VM_RESERVED flag because it cannot be swapped.
> 
> and VM_RESERVED vma isn't core dumped because its flag often be used for
> kernel internal vma (e.g. vmalloc, sound related).
> 
> So, hugepage is never dumped and it indicate hugepages's program can't be debugged easily.
> 
> In these days, demand on making use of hugepage is increasing.
> IMO, native support for coredump of hugepage is useful.
> 
> 
> I think VM_RESERVED default dumping bahavior is good,
> then I'd like to add coredump_filter mask.

> Index: b/Documentation/filesystems/proc.txt
> ===================================================================
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -2389,11 +2389,12 @@ will be dumped when the <pid> process is
>  of memory types. If a bit of the bitmask is set, memory segments of the
>  corresponding memory type are dumped, otherwise they are not dumped.
>  
> -The following 4 memory types are supported:
> +The following 5 memory types are supported:
>    - (bit 0) anonymous private memory
>    - (bit 1) anonymous shared memory
>    - (bit 2) file-backed private memory
>    - (bit 3) file-backed shared memory
> +  - (bit 5) hugetlb memory

Hugetlb VMAs fall also into one of the lowest 4 bit case.
If you introduce the hugetlb bit (bit 5), you'd better describe that
the hugetlb bit takes precedence over the lowest 4 bits.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

