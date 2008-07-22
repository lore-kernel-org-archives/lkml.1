Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYGVNZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYGVNZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYGVNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:25:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYGVNZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:25:08 -0400
Message-ID: <4885DF9D.2090804@zytor.com>
Date: Tue, 22 Jul 2008 09:24:45 -0400
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
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com> <48848DDF.6010903@zytor.com> <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com> <48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu>
In-Reply-To: <20080722131408.GA12418@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> Not a bug.
> 
> it would still be nice to get a nice printk and panic during bootup 
> instead of some obscure crash, hm?
> 

Yes.  The fundamental problem is that Centaur has a set of CPUs which 
report family == 6 but don't have the long NOP instructions.  We would 
need an exact CPUID criterion for these CPUs in order to be able to 
report it as an error.  An alternative would be to attempt trapping in 
the real-mode code (#UD is one of the *very* few CPU exceptions which 
can be reliably captured in real mode on a BIOS system), but doing so 
would probably mean breaking Loadlin at the very least.

We can't "printk and panic" because we never get that far in the kernel 
proper, for obvious reasons: the code is quite littered with these buggers.

	-hpa
