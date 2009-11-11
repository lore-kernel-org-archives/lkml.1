Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZKKW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZKKW1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZKKW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:27:44 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:42061 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759250AbZKKW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:27:43 -0500
Message-ID: <4AFB3A2D.3070908@simtec.co.uk>
Date: Wed, 11 Nov 2009 22:26:53 +0000
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Vincent Sanders <vince@simtec.co.uk>
CC: Krzysztof Helt <krzysztof.h1@wp.pl>, akpm@linux-foundation.org,
       lethal@linux-sh.org, dilinger@debian.org, linux-kernel@vger.kernel.org,
       Simtec Linux Team <linux@simtec.co.uk>
Subject: Re: SM501: Implement acceleration features
References: <20091110171810.584051931@fluff.org.uk>	<20091111005825.801e180e.krzysztof.h1@wp.pl> <20091111214915.GA5182@kyllikki.org>
In-Reply-To: <20091111214915.GA5182@kyllikki.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Sanders wrote:
> On Wed, Nov 11, 2009 at 12:58:25AM +0100, Krzysztof Helt wrote:
>> On Tue, 10 Nov 2009 17:18:10 +0000
>> Ben Dooks <ben@simtec.co.uk> wrote:
>>
>>> From: Vincent Sanders <vince@simtec.co.uk>
>>>
>>> This patch provides the acceleration entry points for the SM501
>>> framebuffer driver.
>>>
>>> This patch provides the sync, copyarea and fillrect entry points,
>>> using the SM501's 2D acceleration engine to perform the operations
>>> in-chip rather than across the bus.
>>>
>>> Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
>>> Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
>>> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
>>>
>>> ---
>>>  drivers/video/sm501fb.c    |  238 ++++++++++++++++++++++++++++++++++++++++++---
>>>  include/linux/sm501-regs.h |    2 
>>>  2 files changed, 226 insertions(+), 14 deletions(-)
>>>
>>> Index: b/drivers/video/sm501fb.c
>>> ===================================================================
>>> --- a/drivers/video/sm501fb.c	2009-11-03 11:19:44.000000000 +0000
>>> +++ b/drivers/video/sm501fb.c	2009-11-03 11:19:46.000000000 +0000
> 
> I have snipped all but small amount for context
> 
>>> +	/* wait for the 2d engine to be ready */
>>> +	while ((count > 0) &&
>>> +	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
>>> +		SM501_SYSCTRL_2D_ENGINE_STATUS) != 0)
>>> +		count--;
>>> +
>> You may add cpu_relax() inside this loop.
>>
> 
> ok, would need to test this thoroughly as the SM501 has some...odd
> behaviours (see later on).
> 
>>> +
>>> +	if (sm501fb_sync(info))
>>> +		return;
>>> +
>> Please check if you need to wait for the blit engine before writting
>> to any register.  Usually, the values in the bit engine registers
>> are shadowed after the engine is started (ie. the blitting operation
>> is started) and the next set of values can be written into the regs.
> 
> indeed, if it were sane I would agree, it isnt in all circumstances, see later

It might be worth caching the data that relies on bpp after set_par
call, and thus avoiding another swtich on bpp in the acceleration
routines.

Otherwise not much else to say.

-- 
Ben Dooks, Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
