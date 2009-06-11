Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZFKHRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZFKHRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZFKHR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:17:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47164 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZFKHR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:17:26 -0400
Date: Thu, 11 Jun 2009 16:15:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Question: elf coredump with an extreme program
Message-Id: <20090611161553.3b1fcc8b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

At first, I don't have any real problem, now. just curious....

Now, sysctl_max_map_count=65536 at default.

And some (silly) program  and increases max_map_count to be very large to
do mmap() more.

Unfortunately, it gets SEGV and  generates a core-dump.
But this core is not readable by gdb.

Because it seems ELF format uses 16bit value for # of sections,
coredump header is corrupted in this case. (secions are crated per
vma.)

gdb shouldn't trust the number of sections in  elf->e_phnum ?
or is there some workaround technique for this problem ?

BTW, I think default limit of 65536 of vma is too large for usual ELF program.
coredump will be corrupted.

Thanks,
-Kame

