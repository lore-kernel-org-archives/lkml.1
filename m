Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZJEP6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZJEP6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZJEP6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:58:16 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40893 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZJEP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=VtfhVV2E2cCbglfSBNlvhRXjGmqOGx8KZ6HFkGQlGMRt/LNVAFOiN4SRv1ooWH4rua
         erpEdFbtKitvnfBBb9o2RiDdWg6M/RqXeIhy2kYJZVJg2WYNdGWDEHSnxur6duGuBbcK
         S5kMck94+8ViuJxU5/4kycIT9t+uEKtzyeshA=
Date: Mon, 5 Oct 2009 23:57:24 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Message-ID: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I've 3 systems with 4GB, 16GB and 64GB all running 32bit with these set:

 	CONFIG_X86_32=y
 	CONFIG_X86=y
 	CONFIG_ZONE_DMA=y
 	# CONFIG_ZONE_DMA32 is not set
 	CONFIG_SPARSEMEM_MANUAL=y
 	CONFIG_SPARSEMEM=y
 	CONFIG_HIGHMEM64G=y
 	CONFIG_HIGHMEM=y
 	CONFIG_X86_PAE=y
 	CONFIG_KSM=y
 	CONFIG_HIGHPTE=y


# using "free -lm" ...

# with 4GB
              total       used       free     shared    buffers     cached
Mem:          3983       3862        120          0        112       3542
Low:           850        738        112
High:         3132       3123          8
-/+ buffers/cache:        207       3775
Swap:         8008          0       8008


# with 16GB
              total       used       free     shared    buffers     cached
Mem:         16244       6570       9673          0        320       5559
Low:           750        717         33
High:        15493       5853       9640
-/+ buffers/cache:        690      15554
Swap:        26709          0      26709


# with 64GB
              total       used       free     shared    buffers     cached
Mem:         63995        524      63470          0          4        365
Low:           378         32        345
High:        63616        492      63124
-/+ buffers/cache:        154      63840
Swap:        28003          0      28003


Question is ... is there anyway to increase "low mem" without resorting to 
migrating to 64bit? (Look... it only has 378MB total low mem vs 850MB on 
the 4GB system). I've oracle installed on the 64GB system and it keeps 
getting OOMs!

I thought CONFIG_HIGHPTE (Allocate 3rd-level pagetables from highmem) is 
supposed to help with low mem as stated here ...

  CONFIG_HIGHPTE:
 	The VM uses one page table entry for each page of physical memory.
 	For systems with a lot of RAM, this can be wasteful of precious
 	low memory.  Setting this option will put user-space page table
 	entries in high memory.


Anything I should do? Slow death using sysctl like this ...
 	vm.min_free_kbytes = 16384
 	vm.overcommit_memory = 2
 	vm.overcommit_ratio = 75
 	vm.vfs_cache_pressure = 10000


Thanks,
Jeff.

P.S.  I was trying to "cross-compile" a gcc compiler, but didn't get far. 
That's a different topic ... offline, please write to me directly if 
you've done this ... would need binutil 64 (compile ok), gcc 64 (stucked 
... seems to be looking for libc 64bit) ...
