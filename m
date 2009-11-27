Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZK0Eml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZK0Eml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZK0Emk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:42:40 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:33760 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751928AbZK0Emj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:42:39 -0500
Message-ID: <4B0F5908.3090900@snapgear.com>
Date: Fri, 27 Nov 2009 14:43:52 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k
 tree
References: <20091126115806.c53684f5.sfr@canb.auug.org.au> <10f740e80911261329s35f62au37e6b209c657e09@mail.gmail.com>
In-Reply-To: <10f740e80911261329s35f62au37e6b209c657e09@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen, Geert,

Geert Uytterhoeven wrote:
> On Thu, Nov 26, 2009 at 01:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Today's linux-next merge of the m68knommu tree got a conflict in
>> arch/m68k/include/asm/ptrace.h between commit
>> 63c361b65f6540043c4baabf1a044a45c7465858 ("m68k: use generic code for
>> ptrace requests") from the m68k tree and commit
>> 03a03164e8084b810e9f92906a51232d63bac72c ("m68knommu: define
>> arch_has_single_step() and friends") from the m68knommu tree.
>>
>> These mostly add the same stuff but not quite :-(
> 
> Ah sorry, my bad. I'm not yet used to the uClinux guys touching "my"
> includes ;-)
> So we need better coordination between us.
> 
> IIRC, Greg's changes were inspired by Andreas' patch.

Yes, largely they are.


>> I have done a fixup (see below) and can carry it as necessary.  Please
>> check the result.
> 
> At first sight, it looks OK. Thanks for fixing it up!

Yep, looks ok from what I can see.

Geert, how do you want to handle for the real linus merge?
Do you want me to drop the changes to ptrace.h from that patch?

Regards
Greg



>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>>
>> diff --cc arch/m68k/include/asm/ptrace.h
>> index eef9309,beb2091..0000000
>> --- a/arch/m68k/include/asm/ptrace.h
>> +++ b/arch/m68k/include/asm/ptrace.h
>> @@@ -86,14 -84,15 +86,18 @@@ struct switch_stack
>>  extern void show_regs(struct pt_regs *);
>>
>>  /*
>>  - * These are defined as per linux/ptrace.h.
>>  + * These are defined as per linux/ptrace.h, which see.
>>   */
>> + struct task_struct;
>> +
>>  -#ifndef CONFIG_MMU
>>  -#define       arch_has_single_step()  (1)
>>  +#define arch_has_single_step()        (1)
>>  extern void user_enable_single_step(struct task_struct *);
>>  extern void user_disable_single_step(struct task_struct *);
>>  +
>> ++#ifdef CONFIG_MMU
>>  +#define arch_has_block_step() (1)
>>  +extern void user_enable_block_step(struct task_struct *);
>> + #endif
>>
>>  #endif /* __KERNEL__ */
>>  #endif /* __ASSEMBLY__ */
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
