Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0BJKF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:05:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46920 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0BJKFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:05:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nf0BTT/+D8sWxI9gvW5xGlM/r3Vhb/bSuMhFlrw2rdptnaUuulSu43kguAMcOxFAJw
         KTS5i6ziwmX8YCPdGKEei5oEk374aCrdD174P5D9vW3r8WGgET7WZbGPcoN8WWrnVsFV
         kG8lZbzLd9uMC4nvENIJD5tscySP1IVs2IJ1Y=
MIME-Version: 1.0
In-Reply-To: <4B71FACB.9040504@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	 <1265743966-17065-29-git-send-email-yinghai@kernel.org>
	 <20100209114916.ba38f57f.akpm@linux-foundation.org>
	 <84144f021002091156q5cbf6adcj3c1d86b00a6e5285@mail.gmail.com>
	 <4B71FACB.9040504@kernel.org>
Date: Wed, 10 Feb 2010 12:05:53 +0200
X-Google-Sender-Auth: ef04cfb65c926ee5
Message-ID: <84144f021002100205v7968a342lb315296eccefb523@mail.gmail.com>
Subject: Re: [PATCH 28/35] radix: move radix init early
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 2:16 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 02/09/2010 11:56 AM, Pekka Enberg wrote:
>> On Tue, Feb 9, 2010 at 9:49 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Tue, 09 Feb 2010 11:32:39 -0800
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> prepare to use it in early_irq_init()
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> ---
>>>>  init/main.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/init/main.c b/init/main.c
>>>> index 4cb47a1..8451878 100644
>>>> --- a/init/main.c
>>>> +++ b/init/main.c
>>>> @@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
>>>>               local_irq_disable();
>>>>       }
>>>>       rcu_init();
>>>> +     radix_tree_init();
>>>>       /* init some links before init_ISA_irqs() */
>>>>       early_irq_init();
>>>>       init_IRQ();
>>>> @@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
>>>>       proc_caches_init();
>>>>       buffer_init();
>>>>       key_init();
>>>> -     radix_tree_init();
>>>>       security_init();
>>>>       vfs_caches_init(totalram_pages);
>>>>       signals_init();
>>>
>>> Probably OK.  Note that radix_tree_init() uses slab, and it is now being
>>> called before the kernel has run kmem_cache_init_late().  So please
>>> ensure that this code was tested with CONFIG_SLAB=y.
>>
>> That should be fine but yeah, definitely needs to be tested.
>
> tested with x86 bit with CONFIG_SLAB=y, and it works.

OK, great. Would be good to have some coverage on other architectures
as well. PPC was one of the archs that blew up last time we changed
init order.
