Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbXLFTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbXLFTP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXLFTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:15:16 -0500
Received: from mail.tmr.com ([64.65.253.246]:43839 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbXLFTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:15:15 -0500
Message-ID: <47584E35.7030409@tmr.com>
Date: Thu, 06 Dec 2007 14:32:05 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de>
In-Reply-To: <20071204161811.GB15974@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
> 
>> While debugging Exim4's GnuTLS interface, I recently found out that
>> reading from /dev/urandom depletes entropy as much as reading from
>> /dev/random would. This has somehow surprised me since I have always
>> believed that /dev/urandom has lower quality entropy than /dev/random,
>> but lots of it.
> 
> man 4 random
> 
>> This also means that I can "sabotage" applications reading from
>> /dev/random just by continuously reading from /dev/urandom, even not
>> meaning to do any harm.
>>
>> Before I file a bug on bugzilla,
>> ...
> 
> The bug would be closed as invalid.
> 
> No matter what you consider as being better, changing a 12 years old and 
> widely used userspace interface like /dev/urandom is simply not an 
> option.

I don't see that he is proposing to change the interface, just how it 
gets the data it provides. Any program which depends on the actual data 
values it gets from urandom is pretty broken, anyway. I think that 
getting some entropy from network is a good thing, even if it's used 
only in urandom, and I would like a rational discussion of checking the 
random pool available when urandom is about to get random data, and 
perhaps having a lower and upper bound for pool size.

That is, if there is more than Nmax random data urandom would take some, 
if there was less than Nmin it wouldn't, and between them it would take 
data, but less often. This would improve the urandom quality in the best 
case, and protect against depleting the /dev/random entropy in low 
entropy systems. Where's the downside?

There has also been a lot of discussion over the years about improving 
the quality of urandom data, I don't personally think making the quality 
higher constitutes "changing a 12 years old and widely used userspace 
interface like /dev/urandom" either.

Sounds like a local DoS attack point to me...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
