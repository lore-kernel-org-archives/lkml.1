Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYIHBvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYIHBvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYIHBvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:51:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58361 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYIHBvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:51:46 -0400
X-AuditID: 0ac90650-aa0c8ba000006fc9-e5-48c48530cefe
Message-ID: <48C48520.9070206@hitachi.com>
Date: Mon, 08 Sep 2008 10:51:28 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
    <20080902134850.GA26372@csn.ul.ie>
In-Reply-To: <20080902134850.GA26372@csn.ul.ie>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added CC to Roland McGrath]

Mel Gorman wrote:

>>--- a/Documentation/filesystems/proc.txt
>>+++ b/Documentation/filesystems/proc.txt
>>@@ -2389,11 +2389,12 @@ will be dumped when the <pid> process is
>> of memory types. If a bit of the bitmask is set, memory segments of the
>> corresponding memory type are dumped, otherwise they are not dumped.
>> 
>>-The following 4 memory types are supported:
>>+The following 5 memory types are supported:
>>   - (bit 0) anonymous private memory
>>   - (bit 1) anonymous shared memory
>>   - (bit 2) file-backed private memory
>>   - (bit 3) file-backed shared memory
>>+  - (bit 5) hugetlb memory
> 
> It's not your fault, but the meaning of bit 4 appears to be
> undocumented. Offhand, does anyone know if this is intentional?

I think it was just forgotten to be updated.  Bit 4 was introduced
by Roland McGrath, and it means elf header pages in file-backed
private VMAs are dumped even if bit 2 is cleared.

Thanks,


Subject: [PATCH] coredump_filter: add description of bit 4

There is no description of bit 4 of coredump_filter in the
documentation.  This patch adds it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
CC: Roland McGrath <roland@redhat.com>
---
 Documentation/filesystems/proc.txt |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.27-rc5/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.27-rc5.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.27-rc5/Documentation/filesystems/proc.txt
@@ -2394,6 +2394,8 @@ The following 4 memory types are support
   - (bit 1) anonymous shared memory
   - (bit 2) file-backed private memory
   - (bit 3) file-backed shared memory
+  - (bit 4) ELF header pages in file-backed private memory areas (it is
+            effective only if the bit 2 is cleared)
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.



