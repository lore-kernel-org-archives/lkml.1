Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXIJC4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXIJC4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXIJC4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:56:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52794 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXIJC4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:56:06 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Aloni <da-x@monatomic.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/kexec.c: make code static
In-reply-to: <20070909202516.GQ3563@stusta.de>
Message-Id: <20070910115549oomichi@mail.jp.nec.com>
References: <20070909202516.GQ3563@stusta.de>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Mon, 10 Sep 2007 11:55:49 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian,


2007/09/09 22:25:16 +0200, Adrian Bunk <bunk@kernel.org> wrote:
>On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>>...
>> Changes since 2.6.23-rc3-mm1:
>>...
>> +add-vmcoreinfo.patch
>>...
>>  misc
>>...
>
>This patch makes the following needlessly global code static:
>- vmcoreinfo_data[]
>- vmcoreinfo_size
>- vmcoreinfo_append_str()

The kernel compiling fails with your patch because architecture-specific
function should access the above data/function:

# make
[snip]
arch/ia64/kernel/machine_kexec.c: In function 'arch_crash_save_vmcoreinfo':
arch/ia64/kernel/machine_kexec.c:134: error: implicit declaration of function 'SYMBOL'
arch/ia64/kernel/machine_kexec.c:135: error: implicit declaration of function 'LENGTH'
arch/ia64/kernel/machine_kexec.c:139: error: implicit declaration of function 'SIZE'
arch/ia64/kernel/machine_kexec.c:139: error: 'node_memblk_s' undeclared (first use in this function)
arch/ia64/kernel/machine_kexec.c:139: error: (Each undeclared identifier is reported only once
arch/ia64/kernel/machine_kexec.c:139: error: for each function it appears in.)
arch/ia64/kernel/machine_kexec.c:140: error: implicit declaration of function 'OFFSET'
arch/ia64/kernel/machine_kexec.c:140: error: 'start_paddr' undeclared (first use in this function)
arch/ia64/kernel/machine_kexec.c:141: error: 'size' undeclared (first use in this function)
arch/ia64/kernel/machine_kexec.c:144: error: implicit declaration of function 'CONFIG'
arch/ia64/kernel/machine_kexec.c:144: error: 'PGTABLE_3' undeclared (first use in this function)
make[1]: *** [arch/ia64/kernel/machine_kexec.o] Error 1
make: *** [arch/ia64/kernel] Error 2
#


Thanks
Ken'ichi Ohmichi
