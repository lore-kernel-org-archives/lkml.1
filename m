Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYGMSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYGMSRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYGMSRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:17:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:47628 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYGMSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KkCbkYjilKV1GhD9SVGTZZNWxywEz6U8Z/jQXcACL1n2QuLtE9JMMKvoYpCXwtsYb3
         b2jsjej1xD0+xDARz7P5v9q1sHsvjhDIdZFe++YYwmDEzpWxJpwI7I43WvEgiY9mi3jA
         O32ZCzwSsKolLtrbqD/frL7MgxWcdOAzJcQrY=
Message-ID: <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com>
Date: Sun, 13 Jul 2008 11:17:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <874p6t25n5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <200807092015.03004.yhlu.kernel@gmail.com>
	 <20080710071640.5035cd70@infradead.org>
	 <874p6t25n5.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 7:57 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
>
>> On Wed, 9 Jul 2008 20:15:02 -0700
>> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>>>
>>>
>>> fix phys_pmd_init to make sure not to return big value than end.
>>>
>>> also print out range split:1G/2M/4K
>>>
>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>>
>> Making an accurate mapping solves a lot of potentially nasty/tricky
>> corner cases, so I like the approach
>
> It also means that e.g. on a 1GB system the direct mapping will
> never use 1GB pages.
>
> And the CPU has to handle this anyways because all the old
> kernels overmap and no x86 CPU can drop support for all old
> kernels.
>
> In the end it means only large systems will benefit from 1GB
> pages, which seems wrong to me.

with this patch, my 256g system still use gbpages for 1g-3g, 4g-256g

YH
