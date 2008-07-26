Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYGZScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYGZScW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYGZScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:32:14 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:3518 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYGZScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:32:14 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot boot
From: Andi Kleen <andi@firstfloor.org>
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
	<48848DDF.6010903@zytor.com>
	<43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
	<48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu>
	<4885DF9D.2090804@zytor.com>
Date: Sat, 26 Jul 2008 20:31:09 +0200
In-Reply-To: <4885DF9D.2090804@zytor.com> (H. Peter Anvin's message of "Tue, 22 Jul 2008 09:24:45 -0400")
Message-ID: <87prp07b0y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jul 2008 18:31:03.0908 (UTC) FILETIME=[C2C21A40:01C8EF4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Ingo Molnar wrote:
>>>
>>> Not a bug.
>> it would still be nice to get a nice printk and panic during bootup
>> instead of some obscure crash, hm?
>>
>
> Yes.  The fundamental problem is that Centaur has a set of CPUs which
> report family == 6 but don't have the long NOP instructions.  We would
> need an exact CPUID criterion for these CPUs in order to be able to
> report it as an error.  An alternative would be to attempt trapping in
> the real-mode code (#UD is one of the *very* few CPU exceptions which
> can be reliably captured in real mode on a BIOS system), but doing so
> would probably mean breaking Loadlin at the very least.
>
> We can't "printk and panic" because we never get that far in the
> kernel proper, for obvious reasons: the code is quite littered with
> these buggers.

This was originally supposed to be handled in the early real mode
head.S code. That is why I put the CPUID checking code in there
to error out early when you can still print to the console
using the BIOS functions.

I suspect this regressed when that code was moved to C, because
now the C compiler generates CMOV early.

How about always building the real mode C code with -march=i386?
It is not performance critical so that is ok.

-Andi
