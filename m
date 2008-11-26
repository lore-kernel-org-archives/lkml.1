Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYKZN45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYKZN45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYKZN4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:56:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:44600 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYKZN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=PqpdpWM1uxT2nNaIaEQ5ZW5yumrYjnoK8PmBQTb2hCrXvnz1m1lyetANT4nxZaq3zl
         mhZpciN/JddSqgP/e+52gUxeO4qdQR6aPvRiNDh9BPJx0vNuu7ksc9dgtIW2T0SZ8bh6
         g+Xf3SQnddTl3+wBD3VkXFb/8mBXf6FYMFHTk=
Message-ID: <7c86c4470811260556l3b161f1fx639d7ee02285a93@mail.gmail.com>
Date: Wed, 26 Nov 2008 14:56:44 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org
In-Reply-To: <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <20081126113309.GS6703@one.firstfloor.org>
	 <20081126230529.ab37fb32.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Nov 26, 2008 at 2:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, Stephen Rothwell wrote:
>> Hi Andi,
>>
>> On Wed, 26 Nov 2008 12:33:09 +0100 Andi Kleen <andi@firstfloor.org> wrote:
>> >
>> > > + * x86 does not need extra alignment requirements for the sampling buffer
>> > > + */
>> > > +#define PFM_ARCH_SMPL_ALIGN_SIZE 0
>> > > +
>> > > +asmlinkage void  pmu_interrupt(void);
>> > > +
>> > > +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
>> >
>> > All these bitmap wrappers just seem like unnecessary obfuscation.
>> > Could you just drop them and call the standard functions directly?
>>
>> These were added after comments from the PowerPC maintainer since how the
>> bitmaps are accessed needs to be arch specific.
>
> Just because perfmon uses u64 for bitfields instead of unsigned
> long, therefor it breaks on BE32 machines.
>
> I have not yet found a good reason why it needs to use u64 instead of
> using what's there already.
>
There is a good reason why we cannot use unsigned long. We must make sure
all data structures exchanged between user mode and the kernel have fixed size.
This way, we can have a 32-bit tool run unmodified on top of a 64-bit kernel AND
we do not need trampoline code to marshall/unmarshall the parameters.

And yes, the abstraction for bitmask ops was introduced because of issues
casting u64 -> unsigned long on Big-Endian32-bit machines such as PPC32.
