Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYHMRqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYHMRqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYHMRqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:46:45 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:20776 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYHMRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wsys/dtL31rHvwWQtYiRGbRFo48BzHY8d6tha3BzFrORFxDPvMu9Kju9Of+TkwO0c6
         P1lO9ajxTEnOmg+QOUIG1R4B7JDAvrOjAIs9P9ZV1xyTYzs2sORfZ4GeygfbZ8aa3I7X
         6Qltt4pDqKFjOFZJYjM7PgmUWQ4TOa03qbe10=
Message-ID: <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com>
Date: Wed, 13 Aug 2008 10:46:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080813173940.GA32214@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
	 <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
	 <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
	 <20080813173940.GA32214@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>> On Thu, Aug 14, 2008 at 1:10 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> > On Wed, Aug 13, 2008 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> btw., could you please check that v2.6.27-rc3 (or later) kernels boot
>> >> fine (with about 8 cpus) even if you have genericarch/bigsmp disabled,
>> >> and do not silently hang as it happened on your box before?
>> >
>> > With 16 CPUs, it still hangs, but now the console is showing the
>> > errors as intended.
>> > ... but it is supposed to hang?
>>
>> I tried with just CONFIG_NR_CPUS=8 and this time it booted, but stange
>> thing is I only see 2 CPUs! To be more precise, it's without both
>> CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
>>
>> And when I tried to enable the CPUs, it complained about:
>>
>> # cat cpu6/online
>> 0
>> # echo 1 > cpu6/online
>> More than 8 CPUs detected - skipping them.
>> Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
>> -bash: echo: write error: Input/output error
>>
>> Prior to the patch, the system booted with all 8 CPUs.

that is new regression...

>>
>> Again, if I enable both CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP,
>> I get all 16 CPUs.
>
> Yinghai, could the APIC ID enumeration be nonsequential and we skip CPUs
> starting at the third one already? I think we should accept all CPUs
> that are within our support range.

will try to clear those bits on smp_sanity_check...

YH
