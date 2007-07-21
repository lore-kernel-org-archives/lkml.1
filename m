Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXGUJGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXGUJGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 05:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbXGUJGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 05:06:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:54358 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbXGUJGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 05:06:04 -0400
Message-ID: <46A1CB36.5010609@m3y3r.de>
Date: Sat, 21 Jul 2007 11:00:38 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New wake ups from sky2
References: <46A10CC3.6050909@m3y3r.de> <20070720225038.7635da3f@oldman>
In-Reply-To: <20070720225038.7635da3f@oldman>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger schrieb:
> Thomas Meyer <thomas@m3y3r.de> wrote:
>
>   
>> Today i did a git pull to be up to date again and i noticed in the
>> powertop tool that i'll get this new entry
>>
>>   14,2% (  9,1)     <kernel core> : sky2_probe (sky2_idle)
>>
>> with around 10 interrupts per second.
>>
>> i think (i.e. i don't know and just guessing!) this commit is
>> responsible for these wake ups:
>>
>> git show eb35cf60e462491249166182e3e755d3d5d91a28
>>
>> Author: Stephen Hemminger <shemminger@osdl.org>
>> Date:   Tue Jun 13 17:17:31 2006 +0900
>>
>>     [PATCH] sky2: stop/start hardware idle timer on suspend/resume
>>
>>     The resume bug was caused not by an early interrupt but because the idle
>>     timeout was not being stopped on suspend.  Also disable hardware IRQ's
>>     on suspend.  Will need to revisit this with hotplug?
>>
>>     Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
>>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>>
>> Any ideas?
>>
>>     
>
> Last version has idle timer enabled.
> It is a tradeoff between device hanging due to lost interrupt or wasting power.
> You can make the timeout longer by setting idle_timeout module parameter larger,
> (or zero which will disable it).
>   
Ok. But do you need to start the timer when no cable is plugged in, like
in the case above?

mfg
thomas

