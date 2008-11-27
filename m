Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYK0JiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYK0JiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYK0JiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:38:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:20717 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYK0JiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=q7Mp/PC5buU/V8/q2Sc9cFSgmD8HiPmPnn3iJClZZLohJ2/fBsRa16WbUQPKviztW7
         aT3hseNVDubAXUX5n83NYBuumBhlfCw43jhKmoQe7qjnuNamUAL1msdbw6sPRGfB4SIe
         /ncBk88HXrPR9SFk0xC7KldD9JNODE7K4LyyQ=
Message-ID: <7c86c4470811270138l5501f53dte1e6d8d6b0817e0e@mail.gmail.com>
Date: Thu, 27 Nov 2008 10:38:08 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811262355100.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262156390.3325@localhost.localdomain>
	 <7c86c4470811261337ic1ea828me5e3ba0de469f4b6@mail.gmail.com>
	 <alpine.LFD.2.00.0811262355100.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thu, Nov 27, 2008 at 12:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, stephane eranian wrote:
>> > What a nonsense. We have a bitmask already. Why not iterate over the
>> > bitmask and be done ?
>> >
>>
>> Bitmask can be sparsed. Num represents the number of bits we have to find.
>> The idea is that we don't need to scan the entire bitmask, we stop as soon as
>> we have found all the bits we care about (i.e., all the bits that are set).
>>
>> Example:
>>          num = 3
>>      bitmask=0000000010001001
>>                                     ^ we will iterate until we are
>> done with that bit.
>
> Errm.
>
> #define for_each_bit(bit, addr, size) \
>        for ((bit) = find_first_bit((addr), (size)); \
>             (bit) < (size); \
>             (bit) = find_next_bit((addr), (size), (bit) + 1))
>
> find_first_bit() and find_next_bit() are single instructions on most
> architectures. "size" is known upfront at setup time of the
> context/set and can be cached.
>
> This takes exactly 3 iterations, while your method needs 8. And it
> gets worse with the following example:
>
> Example:
>  num = 1
>  bitmask=1000 0000 0000 0000 0000 0000 0000 00000
>
>          ^ you will iterate until we are done with that bit (32 times)
>
>  for_each_bit() will iterate exactly _once_.
>
Ok, you've convinced me. I will make the change.
Thanks.
