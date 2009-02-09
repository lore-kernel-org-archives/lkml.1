Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZBIWFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZBIWFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBIWFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:05:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:40229 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654AbZBIWFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:05:18 -0500
Message-ID: <4990A899.8070302@sgi.com>
Date: Mon, 09 Feb 2009 14:05:13 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: include/linux/irq.h:452: error: implicit declaration of	function
 'cpu_to_node'
References: <20090121215306.GA10123@x200.localdomain> <4977B1F1.1090602@sgi.com> <20090209203502.GA7701@x200.localdomain>
In-Reply-To: <20090209203502.GA7701@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Wed, Jan 21, 2009 at 03:38:25PM -0800, Mike Travis wrote:
>> Alexey Dobriyan wrote:
>>> On mips-malta:
>>>
>>>   CC      arch/mips/mti-malta/malta-int.o
>>> In file included from arch/mips/mti-malta/malta-int.c:25:
>>> include/linux/irq.h: In function 'init_alloc_desc_masks':
>>> include/linux/irq.h:452: error: implicit declaration of function 'cpu_to_node'
>>> include/linux/irq.h:454: error: 'GFP_ATOMIC' undeclared (first use in this function)
>>>
>>> I _think_ init_alloc_desc_masks() should be made out of line to fix this.
>> Hi Alexey,
>>
>> Does adding #include <linux/slab.h> fix the error?  If so, I can add this to
>> linux/irq.h.
>>
>> The primary reason it's inline is that unless CONFIG_CPUMASK_OFFSTACK=y, then the
>> entire routine is a NOP which optimizes out more completely as an inline function.
> 
> linux/slab.h helps.

Hi Alexey,

Since you reported this problem a similar issue was discovered on s390.  However
the fix for that was to include interrupt.h instead of irq.h.

Could you try this as well?

Here's a tail end pointer to the thread and Andrew's commit msg including the
patch is below.

http://marc.info/?l=linux-mm-commits&m=123360349631362&w=4

Thanks!
Mike
--- 

Subject: + sysrq-include-interrupth-instead-of-irqh.patch added to -mm tree
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com,
        travis@sgi.com
From: akpm@linux-foundation.org
Date: Tue, 27 Jan 2009 15:24:08 -0800

The patch titled
     sysrq: include interrupt.h instead of irq.h
has been added to the -mm tree.  Its filename is
     sysrq-include-interrupth-instead-of-irqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: include interrupt.h instead of irq.h
From: Heiko Carstens <heiko.carstens@de.ibm.com>

With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
we get this compile bug on s390:

  CC      drivers/char/sysrq.o
In file included from drivers/char/sysrq.c:38:
include/linux/irq.h: In function 'init_alloc_desc_masks':
include/linux/irq.h:442: error: dereferencing pointer to incomplete type

drivers/char/sysrq.c should include interrupt.h instead of irq.h.

Cc: Mike Travis <travis@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~sysrq-include-interrupth-instead-of-irqh drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-include-interrupth-instead-of-irqh
+++ a/drivers/char/sysrq.c
@@ -35,7 +35,7 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
alpha-use-syscall-wrappers.patch
linux-next.patch
sysrq-include-interrupth-instead-of-irqh.patch
kmalloc-return-null-instead-of-link-failure.patch
