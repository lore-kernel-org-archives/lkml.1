Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbZAZPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbZAZPAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZAZPAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:00:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751422AbZAZPAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:00:34 -0500
Message-ID: <497DD00D.4030802@sgi.com>
Date: Mon, 26 Jan 2009 07:00:29 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] sysrq: include interrupt.h instead of irq.h
References: <20090121150249.a87aca09.sfr@canb.auug.org.au>	<1232545758.31303.2.camel@osiris.boeblingen.de.ibm.com>	<4977523B.6000507@sgi.com> <20090126131614.4ad29c15@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090126131614.4ad29c15@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's Heiko's patch in my 'urgent-for-ingo' branch. 

Thanks,
Mike

The following changes since commit c3c467d0aabdbb53863e8722be898770d438c140:
  Ingo Molnar (1):
        fix: crash: IP: __bitmap_intersects+0x48/0x73

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git urgent-for-ingo

Heiko Carstens (1):
      sysrq: include interrupt.h instead of irq.h

 drivers/char/sysrq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Heiko Carstens wrote:
> On Wed, 21 Jan 2009 08:50:03 -0800
> Mike Travis <travis@sgi.com> wrote:
> 
>> Thanks for catching this Heiko!
>> Mike
> 
> Erm... it still breaks. Are you going to add the patch to your tree?
> 
>> Heiko Carstens wrote:
>>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>>
>>> With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
>>> we get this compile bug on s390:
>>>
>>>   CC      drivers/char/sysrq.o
>>> In file included from drivers/char/sysrq.c:38:
>>> include/linux/irq.h: In function 'init_alloc_desc_masks':
>>> include/linux/irq.h:442: error: dereferencing pointer to incomplete type
>>>
>>> drivers/char/sysrq.c should include interrupt.h instead of irq.h.
>>>
>>> Cc: Mike Travis <travis@sgi.com>
>>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>>> ---
>>>  drivers/char/sysrq.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Index: linux-next/drivers/char/sysrq.c
>>> ===================================================================
>>> --- linux-next.orig/drivers/char/sysrq.c
>>> +++ linux-next/drivers/char/sysrq.c
>>> @@ -35,7 +35,7 @@
>>>  #include <linux/vt_kern.h>
>>>  #include <linux/workqueue.h>
>>>  #include <linux/kexec.h>
>>> -#include <linux/irq.h>
>>> +#include <linux/interrupt.h>
>>>  #include <linux/hrtimer.h>
>>>  #include <linux/oom.h>
