Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXERQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXERQww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXERQwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:52:34 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4380 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbXERQwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:52:33 -0400
Message-ID: <464DD9DD.8030603@genesi-usa.com>
Date: Fri, 18 May 2007 17:52:45 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org> <464C99FF.8080404@ru.mvista.com> <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org> <464C9E67.2020909@ru.mvista.com> <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com> <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com> <1179499713.12981.75.camel@chaos> <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
In-Reply-To: <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On May 18, 2007, at 9:48 AM, Thomas Gleixner wrote:
> 
>> On Fri, 2007-05-18 at 15:28 +0100, Matt Sealey wrote:
>>>
>>> I think both the MPC52xx GPT0-7 and the SLT0-1 fulfil this fairly
>>> easily.
>>
>> There is some basic work for MPC5200 available:
>>
>> http://www.pengutronix.de/oselas/bsp/phytec/index_en.html#phyCORE-MPC5200B-tiny
>>
> 
> I asked this earlier, but figured you might have a better insight.  Is
> their value in having 'drivers' for more than one clock source?  I'd say
> most (of not all) the PPC SoCs have timers on the system side that we
> could provide drivers for, I'm just not sure if that does anything for
> anyone.

As I asked after, I'm also very intrigued as to what is going to end
up using these timers, but likewise, not much use writing a driver if
everyone can use the extremely high resolution decrementer all at
once..

As I said before too, at least Intel has decided there is a great need
for up to 256 high resolution timer sources on a system, but since this
is a fairly new concept to Linux (and hrtimers and dynticks too) it
only seems to be used in the case of i8254/RTC emulation, mostly on
x86-64.

I'm looking at it now and finding "users" of hrtimers is looking very
thin on the ground. Maybe it's justified on the basis that more is
better, and having support is preferable to not having it (even if
nobody really uses it) but it seems the entire gamut of timing
possibility in Linux can be handled through a simple, and single,
high resolution timer and a queue of events..

So do we need some more? :D

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
