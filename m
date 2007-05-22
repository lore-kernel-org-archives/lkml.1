Return-Path: <linux-kernel-owner+w=401wt.eu-S1764642AbXEVRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764642AbXEVRDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbXEVRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:03:08 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:55359 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937AbXEVRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:03:06 -0400
Message-ID: <46532247.6030803@s5r6.in-berlin.de>
Date: Tue, 22 May 2007 19:03:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>	 <4650074A.6000307@s5r6.in-berlin.de>	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>	 <46503542.50300@s5r6.in-berlin.de>	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>	 <46504876.9040802@s5r6.in-berlin.de>	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>	 <46505DBD.5010005@s5r6.in-berlin.de> <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
In-Reply-To: <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> >> config A
>> >>         bool-or-tristate "option A"
>> >>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
[...]
> Umm, if A requires helper code N (which is available only on platform X),
[And, I assumed, 'A' works without helper 'N' on all platforms except
'X'.  This is a synthetic example which might not have a real-world
application.]
> then why/how do we want A to depend on platforms _other_ than X?

The expression means:  'A' can be enabled on all platforms.  Except on
platform_X, there it can only be enabled if helper_N is built too.

[...]
>>         depends on PM
>>         depends on SWAP
>>         depends on (X86 && !SMP) ||
>>                    (X86 && SUSPEND_SMP) ||
>>                    (PPC64_SWSUSP && !SMP) ||
>>                    (PPC64_SWSUSP && SUSPEND_SMP) ||
>>                    (FRV   && !SMP) ||
>>                    (PPC32 && !SMP)
> 
> Ok, so perhaps you actually meant X && N_ON_X above.

No.  I meant "(X && N_ON_X) || Any_one_platform_other_than_X" above.

The 2nd example is a whitelist, while the 1st example is some kind of
blacklist.  A real-world example of blacklist style:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a73df4dfdb0e01a1cbf119416a00e520a5e22306
(Lived only 2 days in Linus' tree.)
-- 
Stefan Richter
-=====-=-=== -=-= =-==-
http://arcgraph.de/sr/
