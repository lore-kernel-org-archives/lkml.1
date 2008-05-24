Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbYEXVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbYEXVO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbYEXVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:14:22 -0400
Received: from gw.goop.org ([64.81.55.164]:53747 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYEXVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:14:21 -0400
Message-ID: <4838850E.20101@goop.org>
Date: Sat, 24 May 2008 22:13:50 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Tom Spink <tspink@gmail.com>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
References: <20080524192540.GA28067@uranus.ravnborg.org> <48387F0B.3020506@goop.org> <48388187.2070503@goop.org> <20080524210304.GD2308@cs181133002.pp.htv.fi>
In-Reply-To: <20080524210304.GD2308@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, May 24, 2008 at 09:58:47PM +0100, Jeremy Fitzhardinge wrote:
>   
>> Would
>>
>>    #define KCONFIG(x)   (CONFIG_##x - 0)
>>
>>    if (KCONFIG(PREEMPT)) {
>>        ...
>>    }
>>
>> work?
>>     
>
> $ cat test.c
> #define KCONFIG(x)   (CONFIG_##x - 0)
>
> int main()
> {
>   if (KCONFIG(PREEMPT))
>     ;
>
>   return 0;
> }
> $ gcc -O2 -Wall test.c
> test.c: In function ‘main’:
> test.c:5: error: ‘CONFIG_PREEMPT’ undeclared (first use in this function)
> test.c:5: error: (Each undeclared identifier is reported only once
> test.c:5: error: for each function it appears in.)
>   

You and your scientific method.

Yeah, this is one of those cases where you need cpp to rescan its input 
after pasting, and I don't think it will ever do that.

    J
