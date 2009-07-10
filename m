Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZGJOpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZGJOpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZGJOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:45:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:41904 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751964AbZGJOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:44:59 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18mZVYfnJcm0c+wtLaQ9U6F53sNANo+Q+rQFDwY8T
	114CZ4ntErS0ag
Message-ID: <4A5753E8.9040704@fisher-privat.net>
Date: Fri, 10 Jul 2009 16:44:56 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org> <20090710115238.GA8812@elte.hu> <4A573131.40601@fisher-privat.net> <alpine.LFD.2.00.0907101504030.2768@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907101504030.2768@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Fri, 10 Jul 2009, Alexey Fisher wrote:
>> Ingo Molnar schrieb:
>>> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>>
>>>> On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
>>>>> Hallo Ingo, Richard.
>>>>>
>>>>> I'm getting "Corrupted low memory" trace with my Intel DG45ID board
>>>>> after resume. This board has different dmi-bios-vendor... so probably it
>>>>> will be nice to have it in your patch.
>>>> I'm beginning to think that we should be doing this on all hardware,
>>>> perhaps with a kernel option to disable it for embedded devices that
>>>> really need that 64K. The low-memory corruption issue seems to be very
>>>> widespread.
>>> The problem is that the BIOS corrupted memory that it also marked as
>>> 'usable' in its E820 map it gave to the kernel. If that memory is not
>>> usable, it should not have been marked as such. Also, some of the reports
>>> showed corruption beyond this range so the workaround is not universal.
>>>
>>> So i'd really like to know what is happening there, instead of just zapping
>>> support for 64K of RAM on the majority of Linux systems.
>>>
>>> We might end up doing the same thing in the end (i.e. disable that 64k of
>>> RAM) - but it should be an informed decision, not a wild stab in the dark.
>>>
>>> 	Ingo
>> If i make memory dump like "dd if=/dev/mem of=memdump.dd bs=64k count=1"
>> before and after suspend. Will it help you find out whats happening.
> 
> The corrupted low memory printks contain the modifications. Can you
> post them please ?
> 
> Thanks,
> 
> 	tglx

I dumped all between 0000000 - 00ffff0
and there is changes at:
0004200 ->  this know one
003c000 - 003fff0 -> this was empty and now it looks like VBIOS
00d18a0 -> i don't know

cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009e7ff : System RAM
0009e800-0009ffff : reserved
000e0000-000fffff : reserved
00100000-bd90dfff : System RAM
   01000000-014b1f1b : Kernel code
   014b1f1c-0171265f : Kernel data
   01794000-01842c07 : Kernel bss
.....
