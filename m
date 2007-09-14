Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbXINCti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbXINCti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 22:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXINCta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 22:49:30 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50122 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbXINCta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 22:49:30 -0400
Message-Id: <46E9F6A9.8060500@mxs.nes.nec.co.jp>
Date: Fri, 14 Sep 2007 11:49:13 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] [-mm patch]  Cleanup add-vmcoreinfo.patch v2
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

I updated the cleanup patchset for add-vmcoreinfo.patch.
* Cleanup add-vmcoreinfo.patch v1:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/0318.html

This patchset (v2) includes a new patch[4/4] for adding a prefix
"VMCOREINFO_" to the vmcoreinfo macros. Other patches ([1/4]-[3/4])
don't have any changes.

Changelog:
  - Add "Add a prefix VMCOREINFO_ to the vmcoreinfo macros" patch.

Patchset:
[1/4] Cleanup the coding style according to Andrew's comments:
  http://lists.infradead.org/pipermail/kexec/2007-August/000522.html
  - vmcoreinfo_append_str() should have suitable __attribute__s so that
    the compiler can check its use.
  - vmcoreinfo_max_size should have size_t.
  - Use get_seconds() instead of xtime.tv_sec.
  - Use init_uts_ns.name.release instead of UTS_RELEASE.

[2/4] Add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data.
  The dump filetering command 'makedumpfile'(v1.1.6 or before) had assumed
  the above values, and it was not good from the reliability viewpoint.
  So makedumpfile v1.2.0 came to need these values and I created the patch
  to let the kernel output them.
  makedumpfile site:
  https://sourceforge.net/projects/makedumpfile/

[3/4] Use the existing ia64_tpa() instead of asm code.

[4/4] Add a prefix "VMCOREINFO_" to the vmcoreinfo macros.
  Old vmcoreinfo macros were defined as generic names SYMBOL/SIZE/OFFSET
  /LENGTH/CONFIG, and it is impossible to grep for them. So these names
  should be changed. This discussion is the following:
  http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/0415.html


Thanks
Ken'ichi Ohmichi

