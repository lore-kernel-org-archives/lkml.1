Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYHFS3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYHFS3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYHFS3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:29:17 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:36010 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYHFS3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=flIod49n5ZnCICUjAhlbmSCa3jY3NVMnkymm+QPetIUBCoANDjeuMDGwcE4Umt+QCS
         qog4MzgzIR82vK9wP8TMrcAGCJH4iz3gcnh5BsX5UMt+yBrKFgd8AQ88ZHNd5ohuF0ql
         N3ScWEqge5FTYaDya/m4avTe+aJ3OMYginGmY=
Message-ID: <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:29:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1hc9yjb7x.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 10:37 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> Please check dyn_array support for x86
>> v3: split changing to nr_irqs to small patches
>>     fix checkpatch error
>>     reorder the patch sequence to make dyn_array support go at first
>>         so could use that with arrays other than NR_IRQS
>> v4: add CONFIG_HAVE_SPARSE_IRQ with list to use condensed irq_desc array
>>     so could use 32 init, and init more if needed.
>>
>> now: x86 32bit: have CONFIG_HAVE_DYN_ARRAY
>>      x86 64bit: have CONFIG_HAVE_DYN_ARRAY and CONFIG_HAVE_SPARSE_IRQ
>>
>> left:
>> a. hook irq_2_iommu to irq_desc ?
>> b. expand /proc/interrupts to process > nr_irqs
>> c. expand to use irq > nr_irqs for msi
>>
>> notes: may break some arch compling...
>
> It looks like you might possibly be iterating to something usable.
> Breaking architectures is not acceptable however.
>
> My suggestion for a non-breaking path:
> - Kill NR_IRQS in then generic code.
>  With Alan's serial patch and my kstat patch it looks like we have
>  the worst of that.

will use Alan's patch.at first.
already reused your patch about kstat. and move kstat_irqs to irq_desc.

>
> - Introduce get_irq_desc and the functions or function modifications
>  that pass a struct irq_desc * into the genirq code.
>
>  Although I absolutely hate the name get_irq_desc as it implies we are
>  reference counting something and need a corresponding put_irq_desc.
>  Since the lifetime rules don't require that.  Please just call the
>  function irq_desc().

will check that.

>
> - Update arch/x86 to do everything interesting with irq_desc pointers.
>
> - Start dynamically allocating irq_desc and irq_cfg.

already done in last 10 patches.

YH
