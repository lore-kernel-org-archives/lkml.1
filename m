Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967882Ab0B0HZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:25:22 -0500
Received: from bosmailout07.eigbox.net ([66.96.187.7]:35167 "EHLO
	bosmailout07.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967832Ab0B0HZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:25:20 -0500
X-EN-OrigOutIP: 10.20.18.6
X-EN-IMPSID: mupt1d00307rX7u01uptyg
Message-ID: <4B88BA1B.4050500@jaysonking.com>
Date: Sat, 27 Feb 2010 00:22:19 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Thunderbird/3.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Stable team <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jayson King <dev@jaysonking.com>
Subject: [00/11] fix ext4 deadlock on 2.6.27.y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 69.150.131.230
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Using the kernel 2.6.27.45 with an ext4 filesystem, the same deadlock as
was reported earlier in kernel bugzilla #12579 can occur. Simply running
"dbench 500" on an ext4 filesystem can cause the deadlock in one to two
minutes.

In later stable kernels, the deadlock was fixed by commit 2acf2c26
("ext4: Implement range_cyclic in ext4_da_writepages instead of
write_cache_pages"). I can confirm that the same commit fixes the
deadlock on 2.6.27.y. However, as the code in ext4_da_writepages is
different in 2.6.27.y than in later kernels, it was necessary to add
some other mainline patches before 2acf2c26.

Alltogether, I've added 11 mainline patches including 2acf2c26 to my
local 2.6.27.y kernel, and confirmed that the deadlock is fixed only
when the patch 2acf2c26 is applied.

The 11 patches are:

Aneesh Kumar K.V (10):
      ext4: invalidate pages if delalloc block allocation fails.
      ext4: Make sure all the block allocation paths reserve blocks
      ext4: Add percpu dirty block accounting.
      ext4: Retry block reservation
      ext4: Retry block allocation if we have free blocks left
      ext4: Use tag dirty lookup during mpage_da_submit_io
      vfs: Remove the range_cont writeback mode.
      vfs: Add no_nrwrite_index_update writeback control flag
      ext4: Fix file fragmentation during large file write.
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

Mingming Cao (1):
      percpu counter: clean up percpu_counter_sum_and_set()

All will be posted in a reply to this message, in the order that they apply.

I think these patches should be committed to stable 2.6.27.y.

Most of these patches applied cleanly to 2.6.27.45 with no changes other
than some context lines, but two of the patches needed some very slight
modifications. I'll note the changes that I made to them above my
signed-off line for each.

Jayson

