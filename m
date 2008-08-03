Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYHCFkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYHCFkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 01:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYHCFkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 01:40:06 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:50332 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYHCFkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 01:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OhRBrSrn6Iwy2llBOH1iEzP+ihWMaD20ZDOBJXHh3eOZHgJqEh6SmEMLV43Za+UbXX
         lsy5Ok9A42qwPB78HOtH/GBsyd+UNcKj/quQXS2Du7ikukKLI/y1Feeu3v6MSDn/0SEG
         KDUYh4dK7FYA+aIk/XrixOnlTrXkXpdOeVrSA=
Message-ID: <86802c440808022240k7fa89035ga60cbe9840e9b88@mail.gmail.com>
Date: Sat, 2 Aug 2008 22:40:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH 03/25] add dyn_array support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808022239i447f9627t98e5867b0b08e709@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
	 <871w163fuw.fsf@saeurebad.de>
	 <86802c440808022121u3dcdbda2s5ff463f4b330ca17@mail.gmail.com>
	 <87sktm1yuu.fsf@saeurebad.de>
	 <86802c440808022204s62ff2b35g391125babdb2e8e4@mail.gmail.com>
	 <87od4a1x6y.fsf@saeurebad.de>
	 <86802c440808022239i447f9627t98e5867b0b08e709@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 10:39 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Aug 2, 2008 at 10:31 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> Hi,
>>
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> On Sat, Aug 2, 2008 at 9:55 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>>>> Hi,
>>>>
>>>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>>>
>>>>> On Sat, Aug 2, 2008 at 9:03 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>>>>>>
>>>>>>> could have crazy big arrays and allocate them in bootmem at init stage.
>>>>>>> also also to allocate array according to size we need to use to avoid wasting
>>>>>>> memory
>>>>>>> use CONFIG_HAVE_DYN_ARRAY to enable it or not
>>>>>>>
>>>>>>> usage:
>>>>>>>
>>>>>>> |static struct irq_desc irq_desc_init __initdata = {
>>>>>>> |       .status = IRQ_DISABLED,
>>>>>>> |       .chip = &no_irq_chip,
>>>>>>> |       .handle_irq = handle_bad_irq,
>>>>>>> |       .depth = 1,
>>>>>>> |       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
>>>>>>> |#ifdef CONFIG_SMP
>>>>>>> |       .affinity = CPU_MASK_ALL
>>>>>>> |#endif
>>>>>>> |};
>>>>>>> |
>>>>>>> |static void __init init_work(void *data)
>>>>>>> |{
>>>>>>> |       struct dyn_array *da = data;
>>>>>>> |       struct  irq_desc *desc;
>>>>>>> |       int i;
>>>>>>> |
>>>>>>> |       desc = *da->name;
>>>>>>
>>>>>> Where *da->name might be NULL...
>>>
>>> *da->name = __alloc_bootmem_nopanic(size, da->align, phys);
>>
>> Exactly.  Now, look up the possible return values of
>> __alloc_bootmem_nopanic and we are almost there...
>
> 04 fix that via allocating that all together

should be 05

YH
