Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZK0InO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZK0InO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZK0InN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:43:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60817 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZK0InM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:43:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t4O1DDhxx05Oz5K6zwtu6cxiHBHMLM712eOqPHxPvAmuhe5gD8EyBR3HDnOAZEFhtx
         vtq+KW2raecEcEYddQGtKeMJXHFtDjy5GsdW/OT+52a79TS61Tz6NjIWE4jRIGwwDvDJ
         7CrNiKh9Lm/OQUn7Jm09tm3Kqs8FH8JeAHWyM=
MIME-Version: 1.0
In-Reply-To: <4B0F5908.3090900@snapgear.com>
References: <20091126115806.c53684f5.sfr@canb.auug.org.au>
	 <10f740e80911261329s35f62au37e6b209c657e09@mail.gmail.com>
	 <4B0F5908.3090900@snapgear.com>
Date: Fri, 27 Nov 2009 09:43:17 +0100
X-Google-Sender-Auth: 6caf1413e5748830
Message-ID: <10f740e80911270043h567f6bf3l9fc51cfe5a6ac0af@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 05:43, Greg Ungerer <gerg@snapgear.com> wrote:
> Geert Uytterhoeven wrote:
>>
>> On Thu, Nov 26, 2009 at 01:58, Stephen Rothwell <sfr@canb.auug.org.au>
>> wrote:
>>>
>>> Today's linux-next merge of the m68knommu tree got a conflict in
>>> arch/m68k/include/asm/ptrace.h between commit
>>> 63c361b65f6540043c4baabf1a044a45c7465858 ("m68k: use generic code for
>>> ptrace requests") from the m68k tree and commit
>>> 03a03164e8084b810e9f92906a51232d63bac72c ("m68knommu: define
>>> arch_has_single_step() and friends") from the m68knommu tree.
>>>
>>> These mostly add the same stuff but not quite :-(
>>
>> Ah sorry, my bad. I'm not yet used to the uClinux guys touching "my"
>> includes ;-)
>> So we need better coordination between us.
>>
>> IIRC, Greg's changes were inspired by Andreas' patch.
>
> Yes, largely they are.
>
>
>>> I have done a fixup (see below) and can carry it as necessary.  Please
>>> check the result.
>>
>> At first sight, it looks OK. Thanks for fixing it up!
>
> Yep, looks ok from what I can see.
>
> Geert, how do you want to handle for the real linus merge?
> Do you want me to drop the changes to ptrace.h from that patch?

I can apply your patch (modified to apply on top of Andreas') to the
m68k for-linus branch.
Does that sound OK for you?

>>> --
>>> Cheers,
>>> Stephen Rothwell                    sfr@canb.auug.org.au
>>>
>>> diff --cc arch/m68k/include/asm/ptrace.h
>>> index eef9309,beb2091..0000000
>>> --- a/arch/m68k/include/asm/ptrace.h
>>> +++ b/arch/m68k/include/asm/ptrace.h
>>> @@@ -86,14 -84,15 +86,18 @@@ struct switch_stack
>>>  extern void show_regs(struct pt_regs *);
>>>
>>>  /*
>>>  - * These are defined as per linux/ptrace.h.
>>>  + * These are defined as per linux/ptrace.h, which see.
>>>  */
>>> + struct task_struct;
>>> +
>>>  -#ifndef CONFIG_MMU
>>>  -#define       arch_has_single_step()  (1)
>>>  +#define arch_has_single_step()        (1)
>>>  extern void user_enable_single_step(struct task_struct *);
>>>  extern void user_disable_single_step(struct task_struct *);
>>>  +
>>> ++#ifdef CONFIG_MMU
>>>  +#define arch_has_block_step() (1)
>>>  +extern void user_enable_block_step(struct task_struct *);
>>> + #endif
>>>
>>>  #endif /* __KERNEL__ */
>>>  #endif /* __ASSEMBLY__ */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
