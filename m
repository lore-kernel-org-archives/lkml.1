Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYGVNzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYGVNzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYGVNzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:55:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYGVNzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:55:07 -0400
Message-ID: <4885E6B0.3060504@zytor.com>
Date: Tue, 22 Jul 2008 09:54:56 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com> <48848DDF.6010903@zytor.com> <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com> <48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu> <4885DF9D.2090804@zytor.com> <20080722134601.GA21977@elte.hu>
In-Reply-To: <20080722134601.GA21977@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> We can't "printk and panic" because we never get that far in the 
>> kernel proper, for obvious reasons: the code is quite littered with 
>> these buggers.
> 
> hm. How about to default to a safe NOP all the way up to where we can 
> fix up alternatives and install a different NOP. (which we could also 
> test first via intentionally jumping on it and catching any exception 
> via a special exception handler)
> 

I don't really think that's realistic, especially if gcc starts using 
these instructions (which it really *should*.)

You can make the same argument for every non-i386 instruction (heck, 
even every non-8086 instruction), and it quickly gets unworkable.

Since it is extremely likely that the set of processors affected is now 
bounded, I think it's just a matter of identifying the relevant CPUID 
info.  As far as I know, only VIA is affected.

What is worse is that there are a number of "virtual processors" out 
there which are, in effect, separate implementations of the x86 
architecture, but don't actually identify as anything else.  Several of 
them have broken nopl implementations, but identify as processors which 
are known good in this department.  Again, nothing unique to nopl about 
this, but it's a generic problem.

	-hpa
