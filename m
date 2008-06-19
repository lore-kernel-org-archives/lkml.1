Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYFSFeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYFSFeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYFSFef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:34:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:31324 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYFSFee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,670,1204531200"; 
   d="scan'208";a="343189874"
Message-ID: <4859EFE2.2090202@linux.intel.com>
Date: Wed, 18 Jun 2008 22:34:26 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: kerneloops.org: 2.6.26-rc possible regression in ext3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kerneloops.org stats, a new oops is rapidly climbing the charts.
The oops is a page fault in the ext3 "do_slit" function, and the first
report of it was with 2.6.26-rc6-git3.

It happens with various applications; the backtraces are at:

http://www.kerneloops.org/search.php?search=do_split

but are generally of this pattern:

*do_split
ext3_add_entry
ext3_rename
vfs_rename
... <various paths into vfs_rename> ...

or

*do_split
? add_dirent_to_buf
ext3_add_entry
ext3_new_inode
ext3_add_nondir
ext3_create
vfs_create
....


did we change anything in ext3 this cycle?
