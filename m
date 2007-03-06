Return-Path: <linux-kernel-owner+w=401wt.eu-S933753AbXCFBOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbXCFBOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933755AbXCFBOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:14:35 -0500
Received: from gw.goop.org ([64.81.55.164]:37709 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933753AbXCFBOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:14:34 -0500
Message-ID: <45ECC076.9050209@goop.org>
Date: Mon, 05 Mar 2007 17:14:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu>		<1173101297.26165.39.camel@localhost.localdomain>	<1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com>
In-Reply-To: <45ECBDDC.8080708@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Rusty Russell wrote:
>> On Tue, 2007-03-06 at 00:28 +1100, Rusty Russell wrote:
>>  
>>> On Mon, 2007-03-05 at 13:06 +0100, Ingo Molnar wrote:
>>>    
>>>> Subject: [patch] paravirt: VDSO page is essential
>>>> From: Ingo Molnar <mingo@elte.hu>
>>>>
>>>> commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO
>>>> for CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the
>>>> VDSO is an essential component of Linux, and this change forces all
>>>> of them to use int $0x80 - including sane ones like KVM. (If a
>>>> hypervisor does not handle the VDSO properly then it can work
>>>> things around via the vdso=0 boot option. Or CONFIG_PARAVIRT should
>>>> not have been merged. But in any case, it is a basic taste issue:
>>>> we DO NOT #ifdef around core features like this!)
>>>>       
>>> I agree with the criticism, dislike the snarly comments, and disagree
>>> with this patch.
>>>     
>>
>> And my patch was pretty crack-induced too.  Sorry.
>>
>> I shouldn't have been thinking about using CONFIG options at all: we
>> should simply disable the vdso if CONFIG_COMPAT_VDSO=y when we
>> *actually* reserve top memory.
>>
>> This still need some work (doing that now), but do people like the idea?
>>
>> The current "vdso_disabled" flag merely disabled the ELF note, so it
>> needs to be made a little stronger, to not set up the vdso at all.
>>   
>
> I had just sent this out for internal review...
>

I think Jan's approach is better if it works (since there's no
compromise), but this is better if you want to get something working in
the near term.

    J
