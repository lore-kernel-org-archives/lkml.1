Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYL0LVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYL0LVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYL0LUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:20:54 -0500
Received: from gw.goop.org ([64.81.55.164]:48368 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYL0LUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:20:53 -0500
Message-ID: <49560F8F.9020901@goop.org>
Date: Sat, 27 Dec 2008 22:20:47 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH 2/3] x86-64: Unify x86_*_percpu() functions.
References: <1230052506-5041-1-git-send-email-brgerst@gmail.com> <1230052506-5041-2-git-send-email-brgerst@gmail.com> <49560B87.8090407@goop.org> <20081227110909.GA15377@elte.hu>
In-Reply-To: <20081227110909.GA15377@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Brian Gerst wrote:
>>     
>>> Merge the 32-bit and 64-bit versions of these functions.  Unlike 32-bit,
>>> the segment base is the current cpu's PDA instead of the offset from the
>>> original per-cpu area.  This is because GCC hardcodes the stackprotector
>>> canary at %gs:40.  Since the assembler is incapable of relocating against
>>> multiple symbols, the code ends up looking like:
>>>
>>> 	movq $per_cpu__var, reg
>>> 	subq $per_cpu__pda, reg
>>> 	movq %gs:(reg), reg
>>>
>>> This is still atomic since the offset is a constant (just calculated at
>>> runtime) and not dependant on the cpu number.
>>>   
>>>       
>> Yeah, it's a real pity we can't convince the linker to do this simple 
>> computation as a single %gs:ADDR addressing mode.  On the other hand, if 
>> the compiler can reuse the computation of %reg 2-3 times, then the 
>> generated code could well end up being denser.
>>     
>
> There's a nice project for linker hackers?
>
> I'd like to see some kernel image size measurements done on x86 defconfig 
> to see how much real impact this has on code density. Unless the impact is 
> horribly unacceptable, removing ~200 lines of weird x86-specific APIs is a 
> definitive plus.

Yep, I'm all for it.  I don't think there'll be much of a size impact at 
all.

    J

