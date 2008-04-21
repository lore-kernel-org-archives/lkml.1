Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbYDUNfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbYDUNfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbYDUN3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:29:53 -0400
Received: from sandeen.net ([209.173.210.139]:22280 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbYDUN3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:29:34 -0400
Message-ID: <480C96BC.4020400@sandeen.net>
Date: Mon, 21 Apr 2008 08:29:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080419142329.GA5339@elte.hu> <20080420121803.GK1595@cs181133002.pp.htv.fi> <480B4DB4.8070107@sandeen.net> <200804210945.24479.vda.linux@googlemail.com>
In-Reply-To: <200804210945.24479.vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Sunday 20 April 2008 16:05, Eric Sandeen wrote:
>> Adrian Bunk wrote:
>>> But the more users will get 4k stacks the more testing we have, and the 
>>> better both existing and new bugs get shaken out.
>>>
>>> And if there were only 4k stacks in the vanilla kernel, and therefore 
>>> all people on i386 testing -rc kernels would get it, that would give a 
>>> better chance of finding stack regressions before they get into a 
>>> stable kernel.
>> Heck, maybe you should make it 2k by default in all -rc kernels; that
>> way when people run -final with the 4k it'll be 100% bulletproof, right?
>>  'cause all those piggy drivers that blow a 2k stack will finally have
>> to get fixed?  Or leave it at 2k and find a way to share pages for
>> stacks, think how much memory you could save and how many java threads
>> you could run!
>>
>> 4K just happens to be the page size; other than that it's really just
>> some random/magic number picked, and now dictated that if you (and
>> everyting around you) doesn't fit, you're broken.
> 
> Some number has to be picked. Why fitting in 4k is "bad" and fitting
> in 8k is "not bad"?


Because well-written code in several subsystems, used in combination in
common configurations, does not always fit, that is why.

Show me the "bug" in an nfs+xfs+md+scsi writeback stack oops and I'm
sure it'll get "fixed."  But if it's simply complex code that happens to
need >4k, I will continue to argue that the limited stack size selection
is the problem, not the code running in it.

Perhaps not surprisingly, ext4, which is significantly more complex than
ext3, has many more individual functions > 100 bytes than ext3 has.  As
others have said, there is no trend towards smaller, simpler, less
interesting, and less functional code which fits in a smaller and
smaller footprint in the general case.

If someone has a workload and configuration which happens to fit in 4k
then turn it on, test the heck out of it, and have fun.  I've not seen
what I consider to be a convincing argument for making it the default
for everyone.

-Eric
