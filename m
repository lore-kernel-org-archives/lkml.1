Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab0BIT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:56:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41799 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0BIT4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=psfps+Viy5jtmHDVkRiPbx7m00I6P80+qnyNONr11a0KUCHTdkbnWgaheaM/7RJMdy
         2QWCdvUjDKR+KFkaD35dEavyJ0DwwAzPOWVyBtDH+PT/S1euzcLBk1MViNHrKNJATXHj
         WZA2eBte59aEE2XWEdDYAwYu7i4cbsKY9xOqY=
MIME-Version: 1.0
In-Reply-To: <20100209114916.ba38f57f.akpm@linux-foundation.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	 <1265743966-17065-29-git-send-email-yinghai@kernel.org>
	 <20100209114916.ba38f57f.akpm@linux-foundation.org>
Date: Tue, 9 Feb 2010 21:56:41 +0200
X-Google-Sender-Auth: 3bfc8f6862b19ec1
Message-ID: <84144f021002091156q5cbf6adcj3c1d86b00a6e5285@mail.gmail.com>
Subject: Re: [PATCH 28/35] radix: move radix init early
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 9:49 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 09 Feb 2010 11:32:39 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> prepare to use it in early_irq_init()
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  init/main.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/init/main.c b/init/main.c
>> index 4cb47a1..8451878 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
>>               local_irq_disable();
>>       }
>>       rcu_init();
>> +     radix_tree_init();
>>       /* init some links before init_ISA_irqs() */
>>       early_irq_init();
>>       init_IRQ();
>> @@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
>>       proc_caches_init();
>>       buffer_init();
>>       key_init();
>> -     radix_tree_init();
>>       security_init();
>>       vfs_caches_init(totalram_pages);
>>       signals_init();
>
> Probably OK.  Note that radix_tree_init() uses slab, and it is now being
> called before the kernel has run kmem_cache_init_late().  So please
> ensure that this code was tested with CONFIG_SLAB=y.

That should be fine but yeah, definitely needs to be tested.
