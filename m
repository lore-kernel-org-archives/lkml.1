Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0BJAR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:17:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:33665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0BJAR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:17:27 -0500
Message-ID: <4B71FACB.9040504@kernel.org>
Date: Tue, 09 Feb 2010 16:16:11 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 28/35] radix: move radix init early
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>	 <1265743966-17065-29-git-send-email-yinghai@kernel.org>	 <20100209114916.ba38f57f.akpm@linux-foundation.org> <84144f021002091156q5cbf6adcj3c1d86b00a6e5285@mail.gmail.com>
In-Reply-To: <84144f021002091156q5cbf6adcj3c1d86b00a6e5285@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 11:56 AM, Pekka Enberg wrote:
> On Tue, Feb 9, 2010 at 9:49 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Tue, 09 Feb 2010 11:32:39 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> prepare to use it in early_irq_init()
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  init/main.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/init/main.c b/init/main.c
>>> index 4cb47a1..8451878 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
>>>               local_irq_disable();
>>>       }
>>>       rcu_init();
>>> +     radix_tree_init();
>>>       /* init some links before init_ISA_irqs() */
>>>       early_irq_init();
>>>       init_IRQ();
>>> @@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
>>>       proc_caches_init();
>>>       buffer_init();
>>>       key_init();
>>> -     radix_tree_init();
>>>       security_init();
>>>       vfs_caches_init(totalram_pages);
>>>       signals_init();
>>
>> Probably OK.  Note that radix_tree_init() uses slab, and it is now being
>> called before the kernel has run kmem_cache_init_late().  So please
>> ensure that this code was tested with CONFIG_SLAB=y.
> 
> That should be fine but yeah, definitely needs to be tested.

tested with x86 bit with CONFIG_SLAB=y, and it works.

YH
