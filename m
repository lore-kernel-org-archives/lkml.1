Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXETOl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXETOl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbXETOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:41:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59716 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbXETOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:41:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46505DBD.5010005@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 16:39:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>	 <464F9A7B.1030708@s5r6.in-berlin.de>	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com>	 <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>	 <4650074A.6000307@s5r6.in-berlin.de>	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>	 <46503542.50300@s5r6.in-berlin.de>	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>	 <46504876.9040802@s5r6.in-berlin.de> <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
In-Reply-To: <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> config A
>>         bool-or-tristate "option A"
>>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
> 
> ??? I didn't get this entry,

"A is available if N is there or if it's a platform other than X."

That would be adequate if N is only present and required on platform X.

> can you give a solid example

Nothing exactly of this sort, but compare for example kernel/power/Kconfig:

config SOFTWARE_SUSPEND
	bool "Software Suspend (Hibernation)"
	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) &&
		(!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))

Of course this could be written in a clearer fashion, for example as

	depends on PM
	depends on SWAP
	depends on (X86 && !SMP) ||
	           (X86 && SUSPEND_SMP) ||
	           (PPC64_SWSUSP && !SMP) ||
	           (PPC64_SWSUSP && SUSPEND_SMP) ||
	           (FRV   && !SMP) ||
	           (PPC32 && !SMP)

(Untested.)  Anyway, the dependencies which we are looking at here
should not (and partially even cannot) be declared in reverse.

> (you can consider
> the case at hand, MOUSE_ATARI and ATARI_KBD_CORE itself). Better
> still, if you really think that the above is a better way to solve the
> problem at hand, why don't you submit a patch instead?

Because I am lazy and trust that the platform maintainers know best
about the dependencies of MOUSE_ATARI.  Could also be related to that I
as an Amiga owner cannot really relate to Atari. ;-)  Could also have
something to do with my being busy enough fixing bugs in the drivers I
am familiar with.  (Granted, I should shut up, ignore how Kconfig is
more and more turned into a mess, and concentrate on my primary business.)
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
