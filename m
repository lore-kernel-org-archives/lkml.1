Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZGXJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZGXJon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXJom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:44:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34448 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZGXJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:44:42 -0400
Message-ID: <4A698280.4030600@monstr.eu>
Date: Fri, 24 Jul 2009 11:44:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: generic uaccess.h
References: <4A69651E.7040305@monstr.eu> <200907241120.22483.arnd@arndb.de>
In-Reply-To: <200907241120.22483.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 24 July 2009, Michal Simek wrote:
>> I have just look at asm-generic uaccess.h and there is one thing which
>> seems to me wrong.
>>
>> For put_user macro - you use __copy_to_user but you have for 64bit case
>> ifdef CONFIG_64BIT
>> but  look at fs/eventfd: eventfd_read function. At least for this
>> function(syscall) is necessary "return" 64bit
>> value on 32bit machines too.
>> IMHO that ifdef CONFIG_64BIT shouldn't be there.
>>
>> What do you think?
>> If you agree with me, I'll generate proper patch with description.
> 
> The code was intentional, because 32 bit architectures normally
> don't acces u64 values efficiently. I would expect the memcpy
> to produce better object code in that case.
> Did you see an actual bug in my version or are you only
> guessing that the assignment should work better than the
> memcpy?

I have just compile noMMU version and first bootup failed.
I miss that memcpy after it. Ooou.

I'll let you know what my results are.

Michal

> 
> What object code do you get with
> 
> int test(unsigned long long __user *out, unsigned long long in)
> {
> 	return put_user(in, ptr);
> }
> 
> in both cases?


> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
