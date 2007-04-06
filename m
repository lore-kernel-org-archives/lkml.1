Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXDFUcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXDFUcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXDFUcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:32:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:59245 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbXDFUcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:32:00 -0400
Message-ID: <4616AE9C.9060400@tmr.com>
Date: Fri, 06 Apr 2007 16:33:32 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Ken Chen <kenchen@google.com>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>  <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>  <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>  <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>  <20070330141524.5f6cff29.akpm@linux-foundation.org>  <460FE380.2050608@slax.org> <460FE478.9070901@slax.org> <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com> <Pine.LNX.4.61.0704012106010.16977@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704012106010.16977@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 1 2007 11:10, Ken Chen wrote:
>> On 4/1/07, Tomas M <tomas@slax.org> wrote:
>>
>>> I believe that IF you _really_ need to preserve the max_loop module 
>>> parameter, then the parameter should _not_ be ignored, rather it 
>>> should have the same function like before - to limit the loop driver 
>>> so if you use max_loop=10 for example, it should not allow loop.c to 
>>> create more than 10 loops.
>> Blame on the dual meaning of max_loop that it uses currently: to 
>> initialize a set of loop devices and as a side effect, it also sets 
>> the upper limit.  People are complaining about the former constrain, 
>> isn't it?  Does anyone uses the 2nd meaning of upper limit?
> 
> Who cares if the user specifies max_loop=8 but still is able to open up 
> /dev/loop8, loop9, etc.? max_loop=X basically meant (at least to me) 
> "have at least X" loops ready.
> 
You have just come up with a really good reason not to do unlimited 
loops. With the current limit people can count on a script mounting 
files, or similar, to neither loop for a VERY long time or to eat their 
memory. Whatever you think of programs without limit checking, this 
falls in the range of expecting an unsigned char to have a certain upper 
bound, and argues that the default limit should be the current limit and 
that setting a lower bound should work as a real and enforced limit.

If a new capability is being added, and I think it's a great one, then 
people using the capability should be the ones explicitly doing 
something different. Plauger's law of least astonishment.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
