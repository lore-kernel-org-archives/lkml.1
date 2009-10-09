Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbZJIVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbZJIVlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbZJIVly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:41:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:39677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761501AbZJIVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:41:53 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19EvigtRB9EfqHA0PZX/ZERhIRLc3r5umK7AKVc8n
	A4Q4u5wtJbVKL3
Message-ID: <4ACFADED.2040209@gmx.de>
Date: Fri, 09 Oct 2009 23:41:01 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ralf Baechle <ralf@linux-mips.org>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] kernel/time/tick-sched.c: fix warning of printk's argument
 format
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com> <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain> <200910091542.29457.arnd@arndb.de>
In-Reply-To: <200910091542.29457.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 03:42 PM, Arnd Bergmann wrote:
> On Thursday 08 October 2009, Linus Torvalds wrote:
>> for some unfathomable reason. Quite frankly, I think Arnd just screwed up
>> the "generic" version, and the fix is almost certainly to just make the
>> generic version match all the main architectures.
>>
>> I don't have any architectures using the generic header file, though, so
>> I'm not going to do that change blindly. People who do should look at it
>> (alpha, powerpc and mips look like the only ones that might be 64-bit, but
>> I didn't check very carefully - just grepped for it)
>>
>> Added Cc's for some people that have worked on, or used, that generic
>> header file. Is there any possible reason why it is "unsigned long" in
>> that one?
>
> It was intentional to make it unsigned long in the asm-generic
> version, based on the observation that some of the 64-bit architectures
> (alpha and parisc) were using unsigned long in their arch specific
> files. The original parisc file contained
>
> typedef struct {
>         unsigned long __softirq_pending; /* set_bit is used on this */
> } ____cacheline_aligned irq_cpustat_t;
>
> which would imply that unsigned int wouldn't work for it, and looked
> like a good idea. It turns out that the comment is outdated, set_bit
> hasn't been used on __softirq_pending on any architecture for a long
> time as far as I can tell, and 32 bits is obviously enough for it.

Yes, I just tested it on the parisc architecture.
It seems we don't even touch this variable in our code.

> The patch that Ralf just sent looks good therefore, but I'd suggest
> either reverting two of Christophs patches that changed parisc and alpha
> just to be on the safe side, or getting explicit Acks for Ralfs patch
> from the maintainers of those two architectures.

Don't revert for parisc, as either "unsigned long" or "unsigned int" is OK.
So, Ralf's patch (switching __softirq_pending back to "unsigned int") get's my Ack:
Acked-by: Helge Deller <deller@gmx.de>

Helge
