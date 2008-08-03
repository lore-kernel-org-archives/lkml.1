Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYHCFcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYHCFcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYHCFb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:31:58 -0400
Received: from saeurebad.de ([85.214.36.134]:60381 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYHCFb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:31:57 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/25] add dyn_array support
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
	<871w163fuw.fsf@saeurebad.de>
	<86802c440808022121u3dcdbda2s5ff463f4b330ca17@mail.gmail.com>
	<87sktm1yuu.fsf@saeurebad.de>
	<86802c440808022204s62ff2b35g391125babdb2e8e4@mail.gmail.com>
Date: Sun, 03 Aug 2008 07:31:33 +0200
In-Reply-To: <86802c440808022204s62ff2b35g391125babdb2e8e4@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 2 Aug 2008 22:04:28 -0700")
Message-ID: <87od4a1x6y.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Sat, Aug 2, 2008 at 9:55 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> Hi,
>>
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> On Sat, Aug 2, 2008 at 9:03 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>>>> Hi,
>>>>
>>>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>>>
>>>>> could have crazy big arrays and allocate them in bootmem at init stage.
>>>>> also also to allocate array according to size we need to use to avoid wasting
>>>>> memory
>>>>> use CONFIG_HAVE_DYN_ARRAY to enable it or not
>>>>>
>>>>> usage:
>>>>>
>>>>> |static struct irq_desc irq_desc_init __initdata = {
>>>>> |       .status = IRQ_DISABLED,
>>>>> |       .chip = &no_irq_chip,
>>>>> |       .handle_irq = handle_bad_irq,
>>>>> |       .depth = 1,
>>>>> |       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
>>>>> |#ifdef CONFIG_SMP
>>>>> |       .affinity = CPU_MASK_ALL
>>>>> |#endif
>>>>> |};
>>>>> |
>>>>> |static void __init init_work(void *data)
>>>>> |{
>>>>> |       struct dyn_array *da = data;
>>>>> |       struct  irq_desc *desc;
>>>>> |       int i;
>>>>> |
>>>>> |       desc = *da->name;
>>>>
>>>> Where *da->name might be NULL...
>
> *da->name = __alloc_bootmem_nopanic(size, da->align, phys);

Exactly.  Now, look up the possible return values of
__alloc_bootmem_nopanic and we are almost there...

	Hannes
