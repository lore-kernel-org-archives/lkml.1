Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbXIJHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbXIJHXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 03:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbXIJHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 03:23:05 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58148 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXIJHXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 03:23:04 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: [PATCH 0/3] [-mm patch] Cleanup add-vmcoreinfo.patch
Message-Id: <20070910162305oomichi@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Mon, 10 Sep 2007 16:23:05 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> Changes since 2.6.23-rc3-mm1:
> [snip]
> +add-vmcoreinfo.patch
>

Thank you for merging add-vmcoreinfo.patch.
I created the patchset for your comments and some corrections.
The patchset is for linux-2.6.23-rc4-mm1.

[1/3] Cleanup the coding style according to Andrew's comments:
http://lists.infradead.org/pipermail/kexec/2007-August/000522.html
- vmcoreinfo_append_str() should have suitable __attribute__s so that
  the compiler can check its use.
- vmcoreinfo_max_size should have size_t.
- Use get_seconds() instead of xtime.tv_sec.
- Use init_uts_ns.name.release instead of UTS_RELEASE.

[2/3] Add nodemask_t's size and NR_FREE_PAGES's value to vmcoreinfo_data.
  The dump filetering command 'makedumpfile'(v1.1.6 or before) had assumed
  the above values, and it was not good from the reliability viewpoint.
  So makedumpfile v1.2.0 came to need these values and I created the patch
  to let the kernel output them.
  makedumpfile site:
  https://sourceforge.net/projects/makedumpfile/

[3/3] Use the existing ia64_tpa() instead of asm code.


Thanks
Ken'ichi Ohmichi
