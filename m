Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbXILHie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbXILHie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXILHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:38:25 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57280 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbXILHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:38:25 -0400
Message-Id: <46E7972A.7000107@mxs.nes.nec.co.jp>
Date: Wed, 12 Sep 2007 16:37:14 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       kexec@lists.infradead.org, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/kexec.c: make code static
References: <20070909202516.GQ3563@stusta.de> <20070910115549oomichi@mail.jp.nec.com> <20070910122040.GE3563@stusta.de> <20070911055327.GA14117@in.ibm.com>
In-Reply-To: <20070911055327.GA14117@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian, Maneesh,

Maneesh Soni wrote:
 > On Mon, Sep 10, 2007 at 02:20:40PM +0200, Adrian Bunk wrote:
 >> On Mon, Sep 10, 2007 at 11:55:49AM +0900, Ken'ichi Ohmichi wrote:
 >>> Hi Adrian,
 >>>
 >>>
 >>> 2007/09/09 22:25:16 +0200, Adrian Bunk <bunk@kernel.org> wrote:
 >>>> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
 >>>>> ...
 >>>>> Changes since 2.6.23-rc3-mm1:
 >>>>> ...
 >>>>> +add-vmcoreinfo.patch
 >>>>> ...
 >>>>>  misc
 >>>>> ...
 >>>> This patch makes the following needlessly global code static:
 >>>> - vmcoreinfo_data[]
 >>>> - vmcoreinfo_size
 >>>> - vmcoreinfo_append_str()
 >>> The kernel compiling fails with your patch because architecture-specific
 >>> function should access the above data/function:
 >>>
 >>> # make
 >>> [snip]
 >>> arch/ia64/kernel/machine_kexec.c: In function 'arch_crash_save_vmcoreinfo':
 >>> arch/ia64/kernel/machine_kexec.c:134: error: implicit declaration of function 'SYMBOL'
 >>> arch/ia64/kernel/machine_kexec.c:135: error: implicit declaration of function 'LENGTH'
 >>> arch/ia64/kernel/machine_kexec.c:139: error: implicit declaration of function 'SIZE'
 >>> arch/ia64/kernel/machine_kexec.c:139: error: 'node_memblk_s' undeclared (first use in this function)
 >>> arch/ia64/kernel/machine_kexec.c:139: error: (Each undeclared identifier is reported only once
 >>> arch/ia64/kernel/machine_kexec.c:139: error: for each function it appears in.)
 >>> arch/ia64/kernel/machine_kexec.c:140: error: implicit declaration of function 'OFFSET'
 >>> arch/ia64/kernel/machine_kexec.c:140: error: 'start_paddr' undeclared (first use in this function)
 >>> arch/ia64/kernel/machine_kexec.c:141: error: 'size' undeclared (first use in this function)
 >>> arch/ia64/kernel/machine_kexec.c:144: error: implicit declaration of function 'CONFIG'
 >>> arch/ia64/kernel/machine_kexec.c:144: error: 'PGTABLE_3' undeclared (first use in this function)
 >>> make[1]: *** [arch/ia64/kernel/machine_kexec.o] Error 1
 >>> make: *** [arch/ia64/kernel] Error 2
 >>> #
 >> Thanks, I missed this.
 >>
 >> That's 80% my fault and 20% the fault of the usage of generic names SYMBOL/SIZE/OFFSET/LENGTH/CONFIG making it impossible to grep for them (and namespace conflicts quite possible).

I understand your motivation. It is better to change these names as you said.


 >> Can we get these #define's properly prefixed (e.g. KEXEC_SYMBOL etc.) so that other people will not repeat my mistake and namespace conflicts will be prevented?
 >>
 >
 > CRASH_DUMP_ or VMCORE_ should be a better prefix as the dump filtering
 > functionality not directly related to kexec.

I think that VMCOREINFO_ is a better prefix, because these macros are for
writing the information to the vmcoreinfo data.


Thanks
Ken'ichi Ohmichi
