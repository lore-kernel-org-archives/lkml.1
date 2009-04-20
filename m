Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZDTJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZDTJFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZDTJFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:05:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45749 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZDTJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:05:20 -0400
Message-ID: <49EC3AB5.5070902@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 18:04:53 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 2/3] x86, mce: Revert "add mce=nopoll option
 to disable timer polling"
References: <49EBCDB0.7000505@jp.fujitsu.com>	<49EBCF67.1060400@jp.fujitsu.com> <87r5znpyze.fsf@basil.nowhere.org>
In-Reply-To: <87r5znpyze.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> 
>> Disabling only polling but not cmci is pointless setting.
>> Instead of "mce=nopoll" which tend to be paired with cmci disablement,
>> it rather make sense to have a "mce=ignore_ce" option that disable
>> both of polling and cmci at once.  A patch for this new implementation
>> will follow this reverting patch.
>>
>> OTOH, once booted, we can disable polling by setting check_interval
>> to 0, but there are no mention about the fact.  Later Andi will post
>> updated documents that can respond this issue.
> 
> I still think that patch has bad semantics because you leave around
> the events in the machine check registers and never clear
> them. Especially with MCA recovery that has very unfortunate side
> effects -- it means the OVER bit will be set and a in principle
> recoverable MCA will require a panic. Even without MCA recovery it has
> similar problems and will lead to confusing log output for non CE
> MCAs.
> 
> I think a patch to not log corrected errors would be reasonable,
> but you still need to clear the events from the machine check
> banks at least.
> 
> So I would recommend you add a mce=dont_log_ce or somesuch
> that just guards the mce_log() call in machine_check_poll()

I suppose there are two possible situations:

1) There is a agent checking/clearing corrected errors
   (such as BIOS) other than OS.

   In this case, clearing MSRs by OS is not applicable.
   So ignore_ce is better option here.

2) There is no agent checking/clearing corrected errors.
   User just want to suppress logs of corrected errors.

   In this case, dont_log_ce would be better option.
   (Or adding filter to mcelog would be another solution)

I don't mind adding three options (no_cmci/ignore_ce/dont_log_ce)
at once.  I'll rework 3/3 of this series to do so.

> Also for your use case really the better way would be to use
> some way to let the firmware communicate that it doesn't want the OS
> to log.

Yes.  However AFAIK there is no way to do it yet.

> Also BTW before adding new features like this it would be a good
> idea to first add the bug fixes I posted two weeks ago.
> 
> -Andi

The original of this repost were posted about three weeks ago (Apr.2)...

I think your patches will go smoothly if my revert patches added before
them.

BTW, could you give me your Acked-by on this 2/3 too?


Thanks,
H.Seto

