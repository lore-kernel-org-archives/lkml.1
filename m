Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZBIWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZBIWcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZBIWcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:32:14 -0500
Received: from relay3.sgi.com ([192.48.171.31]:43306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754226AbZBIWcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:32:13 -0500
Message-ID: <4990AEEB.6000202@sgi.com>
Date: Mon, 09 Feb 2009 14:32:11 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: include/linux/irq.h:452: error: implicit declaration of	function
 'cpu_to_node'
References: <20090121215306.GA10123@x200.localdomain> <4977B1F1.1090602@sgi.com> <20090209203502.GA7701@x200.localdomain> <4990A899.8070302@sgi.com> <4990A96A.3060603@sgi.com> <20090209222910.GA9768@x200.localdomain>
In-Reply-To: <20090209222910.GA9768@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Feb 09, 2009 at 02:08:42PM -0800, Mike Travis wrote:
>> Mike Travis wrote:
>>> Alexey Dobriyan wrote:
>>>> On Wed, Jan 21, 2009 at 03:38:25PM -0800, Mike Travis wrote:
>>>>> Alexey Dobriyan wrote:
>>>>>> On mips-malta:
>>>>>>
>>>>>>   CC      arch/mips/mti-malta/malta-int.o
>>>>>> In file included from arch/mips/mti-malta/malta-int.c:25:
>>>>>> include/linux/irq.h: In function 'init_alloc_desc_masks':
>>>>>> include/linux/irq.h:452: error: implicit declaration of function 'cpu_to_node'
>>>>>> include/linux/irq.h:454: error: 'GFP_ATOMIC' undeclared (first use in this function)
>>>>>>
>>>>>> I _think_ init_alloc_desc_masks() should be made out of line to fix this.
>>>>> Hi Alexey,
>>>>>
>>>>> Does adding #include <linux/slab.h> fix the error?  If so, I can add this to
>>>>> linux/irq.h.
>>>>>
>>>>> The primary reason it's inline is that unless CONFIG_CPUMASK_OFFSTACK=y, then the
>>>>> entire routine is a NOP which optimizes out more completely as an inline function.
>>>> linux/slab.h helps.
>>> Hi Alexey,
>>>
>>> Since you reported this problem a similar issue was discovered on s390.  However
>>> the fix for that was to include interrupt.h instead of irq.h.
>>>
>>> Could you try this as well?
>>>
>>> Here's a tail end pointer to the thread and Andrew's commit msg including the
>>> patch is below.
>>>
>>> http://marc.info/?l=linux-mm-commits&m=123360349631362&w=4
>> Sorry, I should have made a patch specific to mips, and here that is...
> 
> Removal helps independently. ;-)

Hmm, yes, obviously... ;-)
> 
> Oh and please fold all of this into relevant commit.

Done.
>
> P.S.: irq related headers suck.

Agreed.  ;-)

Andrew - is this something you can push via -mm?

Thanks!
Mike
---

Subject: mips: include interrupt.h instead of irq.h

Impact: fix build error on mips arch

Alexey Dobriyan wrote:
> On mips-malta:
>
>   CC      arch/mips/mti-malta/malta-int.o
> In file included from arch/mips/mti-malta/malta-int.c:25:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:452: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:454: error: 'GFP_ATOMIC' undeclared (first use in this function)
...
> Removal helps independently.  ;-) 

This fix is similar to an issue on s390.

Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/mips/mti-malta/malta-int.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6-linus.orig/arch/mips/mti-malta/malta-int.c
+++ linux-2.6-linus/arch/mips/mti-malta/malta-int.c
@@ -22,7 +22,6 @@
  * with two internal 82C95 interrupt controllers.
  */
 #include <linux/init.h>
-#include <linux/irq.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>

