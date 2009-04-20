Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZDTKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZDTKAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZDTKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:00:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDTKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:00:08 -0400
Date: Mon, 20 Apr 2009 12:03:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 2/3] x86, mce: Revert "add mce=nopoll option to disable timer polling"\
Message-ID: <20090420100323.GW14687@one.firstfloor.org>
References: <49EBCDB0.7000505@jp.fujitsu.com> <49EBCF67.1060400@jp.fujitsu.com> <87r5znpyze.fsf@basil.nowhere.org> <49EC3AB5.5070902@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC3AB5.5070902@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) There is a agent checking/clearing corrected errors
>    (such as BIOS) other than OS.
> 
>    In this case, clearing MSRs by OS is not applicable.
>    So ignore_ce is better option here.

Yes, but how do you make sure the option is set when the agent is active?
I think relying on a kernel boot option here is quite fragile.
Also it's something the administrator shouldn't be involved in.

> 
> 2) There is no agent checking/clearing corrected errors.
>    User just want to suppress logs of corrected errors.
> 
>    In this case, dont_log_ce would be better option.
>    (Or adding filter to mcelog would be another solution)
> 
> I don't mind adding three options (no_cmci/ignore_ce/dont_log_ce)
> at once.  I'll rework 3/3 of this series to do so.
> 
> > Also for your use case really the better way would be to use
> > some way to let the firmware communicate that it doesn't want the OS
> > to log.
> 
> Yes.  However AFAIK there is no way to do it yet.

We can just define one. We had Linux specific extensions before.
Just needs a new bit somewhere. I think that would give a better
experience for your customers.

There might be something forthcomming that could be usable in fact.

> The original of this repost were posted about three weeks ago (Apr.2)...
> 
> I think your patches will go smoothly if my revert patches added before
> them.

The bug fixes should go in 2.6.30. After all that is what the rc stage
is for -- applying bug fixed.

> BTW, could you give me your Acked-by on this 2/3 too?

Not yet sorry.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
