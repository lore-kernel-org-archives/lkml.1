Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYGHMsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYGHMsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYGHMqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:46:06 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:44251 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbYGHMqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:46:04 -0400
Message-Id: <4873279E.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 08 Jul 2008 06:38:54 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <rostedt@goodmis.org>, <peterz@infradead.org>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
 <20080630131511.GA7506@elte.hu> <4868DCC7.BA47.005A.0@novell.com>
 <20080703144124.GA653@elte.hu> <20080703151209.GA17059@elte.hu>
In-Reply-To: <20080703151209.GA17059@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Jul 3, 2008 at 11:12 AM, in message <20080703151209.GA17059@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> 
>> * Gregory Haskins <ghaskins@novell.com> wrote:
>> 
>> > I may have found the issue: It looks like the hunk that initially 
>> > disables interrupts in load_balance_newidle() was inadvertently 
>> > applied to load_balance() instead during the merge to linux-tip.  If 
>> > you fold the following patch into my original patch, it should set 
>> > things right again.
>> 
>> ah, sorry - indeed! I've reactivated your patch and i'm testing it 
>> now.
> 
> -tip testing found that it still hangs at:

Hmm..my fix + your config booted for me at the time I submitted it.  I will try to repro
this issue with the new info.

Regards,
-Greg

> 
>  Intel machine check architecture supported.
>  Intel machine check reporting enabled on CPU#1.
>  x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
>  CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
>  Brought up 2 CPUs
>  Total of 2 processors activated (8044.97 BogoMIPS).
>  [...]
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Thu_Jul__3_16_49_53_CEST_2008.bad
> 
> on 3 separate test-systems.
> 
> I've again reverted both your fixup and the original commit. I've pushed 
> out the failing tree to the tmp.sched/devel.fe6149f5e82 -tip branch, you 
> should be able to reproduce it.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


