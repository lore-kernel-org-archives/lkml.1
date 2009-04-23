Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZDWC7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZDWC7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDWC65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:58:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56686 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZDWC64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:58:56 -0400
Message-ID: <49EFD948.7050803@cn.fujitsu.com>
Date: Thu, 23 Apr 2009 10:58:16 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com> <20090420144816.GA13307@linux> <49ED1E66.6030604@cn.fujitsu.com> <20090421095848.GB13699@linux> <49EE6E3C.8050409@cn.fujitsu.com> <20090422124328.GA32007@linux>
In-Reply-To: <20090422124328.GA32007@linux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> On Wed, Apr 22, 2009 at 09:09:16AM +0800, Gui Jianfeng wrote:
>> Andrea Righi wrote:
>>> On Tue, Apr 21, 2009 at 09:16:22AM +0800, Gui Jianfeng wrote:
>>>> Andrea Righi wrote:
>>>>> On Mon, Apr 20, 2009 at 04:39:29PM +0800, Gui Jianfeng wrote:
>>>>>> Andrea Righi wrote:
>>>>>> ...
>>>>>>> Implementation
>>>>>>> ~~~~~~~~~~~~~~
>>>>>>> Patchset against latest Linus' git:
>>>>>>>
>>>>>>>   [PATCH 0/7] cgroup: block device IO controller (v14)
>>>>>>>   [PATCH 1/7] io-throttle documentation
>>>>>>>   [PATCH 2/7] res_counter: introduce ratelimiting attributes
>>>>>>>   [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
>>>>>>>   [PATCH 4/7] io-throttle controller infrastructure
>>>>>>>   [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
>>>>>>>   [PATCH 6/7] io-throttle instrumentation
>>>>>>>   [PATCH 7/7] export per-task io-throttle statistics to userspace
>>>>>>   Hi Andrea,
>>>>>>
>>>>>>   I'd like to have a try this patchset, would you tell what's the kernel version
>>>>>>   and bio-cgroup version based on?
>>>>>>
>>>>> Latest Linus' git is the kernel and bio-cgroup v7 (from
>>>>> http://people.valinux.co.jp/~ryov/bio-cgroup/).
>>>>   Sorry, I still can't apply it...
>>>>
>>>> [root@localhost linux-2.6.30-rc1]# patch -p1 --dry-run < ../cgroup-io-throttle-v14.patch                                                                                         patching file Documentation/cgroups/io-throttle.txt
>>>> patching file block/Makefile
>>>> patching file block/blk-core.c
>>>> patching file block/blk-io-throttle.c
>>>> patching file block/kiothrottled.c
>>>> patching file fs/aio.c
>>>> patching file fs/buffer.c
>>>> Hunk #1 FAILED at 36.
>>>> Hunk #2 FAILED at 669.
>>>> 2 out of 2 hunks FAILED -- saving rejects to file fs/buffer.c.rej
>>>> patching file fs/proc/base.c
>>>> patching file include/linux/blk-io-throttle.h
>>>> patching file include/linux/cgroup_subsys.h
>>>> Hunk #1 succeeded at 49 (offset 6 lines).
>>>> patching file include/linux/memcontrol.h
>>>> Reversed (or previously applied) patch detected!  Assume -R? [n] n
>>>> Apply anyway? [n] n
>>>> Skipping patch.
>>>> 2 out of 2 hunks ignored -- saving rejects to file include/linux/memcontrol.h.rej
>>>> patching file include/linux/mmzone.h
>>>> Hunk #1 FAILED at 607.
>>>> Hunk #2 FAILED at 958.
>>>> ...
>>> Could you checkout the latest Linus' git?
>>>
>>> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
>>>
>>> Or at least try with 2.6.30-rc2. It should apply cleanly also to this
>>> version.
>>   Yes, I tried them all, but didn't work. :(
>>   Would you try "cgroup-io-throttle-v14.patch" too?
> 
> It works for me:
> 
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6
> $ cd linux-2.6
> $ wget http://download.systemimager.org/~arighi/linux/patches/io-throttle/cgroup-io-throttle-v14.patch
> $ git apply cgroup-io-throttle-v14.patch
> (no error reported)
> 
> The same for v13.

  Ok, so we don't need to apply bio-cgroup.... I made a mistake, i applied bio-cgroup firstly :(
  It's Ok now, thanks for the explanation.

  I tried to build, but got the following error.

LD      .tmp_vmlinux1
block/built-in.o: In function `get_iothrottle_from_page':
/kernel/linux-2.6.30-rc2/block/blk-io-throttle.c:670: undefined reference to `page_cgroup_get_owner'
block/built-in.o: In function `iothrottle_set_page_owner':
/kernel/linux-2.6.30-rc2/block/blk-io-throttle.c:704: undefined reference to `page_cgroup_set_owner'
block/built-in.o: In function `iothrottle_copy_page_owner':
/kernel/linux-2.6.30-rc2/block/blk-io-throttle.c:720: undefined reference to `page_cgroup_copy_owner'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 mm/page_cgroup.c |   65 ++++++++++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index b3b394c..9c392f1 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -244,6 +244,38 @@ static int __meminit page_cgroup_callback(struct notifier_block *self,
 
 #endif
 
+void __init page_cgroup_init(void)
+{
+	unsigned long pfn;
+	int fail = 0;
+
+	if (mem_cgroup_disabled() && iothrottle_disabled())
+		return;
+
+	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
+		if (!pfn_present(pfn))
+			continue;
+		fail = init_section_page_cgroup(pfn);
+	}
+	if (fail) {
+		printk(KERN_CRIT
+			"try cgroup_disable=memory,blockio boot option\n");
+		panic("Out of memory");
+	} else {
+		hotplug_memory_notifier(page_cgroup_callback, 0);
+	}
+	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
+	printk(KERN_INFO
+		"try cgroup_disable=memory,blockio option if you don't want\n");
+}
+
+void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
+{
+	return;
+}
+
+#endif
+
 /**
  * page_cgroup_get_owner() - get the owner ID of a page
  * @page:	the page we want to find the owner
@@ -317,39 +349,6 @@ int page_cgroup_copy_owner(struct page *npage, struct page *opage)
 	return 0;
 }
 
-void __init page_cgroup_init(void)
-{
-	unsigned long pfn;
-	int fail = 0;
-
-	if (mem_cgroup_disabled() && iothrottle_disabled())
-		return;
-
-	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
-			continue;
-		fail = init_section_page_cgroup(pfn);
-	}
-	if (fail) {
-		printk(KERN_CRIT
-			"try cgroup_disable=memory,blockio boot option\n");
-		panic("Out of memory");
-	} else {
-		hotplug_memory_notifier(page_cgroup_callback, 0);
-	}
-	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO
-		"try cgroup_disable=memory,blockio option if you don't want\n");
-}
-
-void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
-{
-	return;
-}
-
-#endif
-
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 
 static DEFINE_MUTEX(swap_cgroup_mutex);
-- 
1.5.4.rc3




