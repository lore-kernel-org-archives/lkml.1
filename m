Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXGWF1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXGWF1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbXGWF1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:27:07 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59627
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbXGWF1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:27:06 -0400
Date: Sun, 22 Jul 2007 22:25:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Igor Stoppa <igor.stoppa@nokia.com>,
       "ext linux-pm-bounces@lists.linux-foundation.org" 
	<linux-pm-bounces@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
In-Reply-To: <1185164357.2714.49.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0707222207210.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> 
 <1185091022.19678.28.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm> 
 <1185105911.29238.43.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm> 
 <1185145766.2714.27.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0707221914550.6350@asgard.lang.hm> 
 <1185162647.2714.35.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0707222054060.6350@asgard.lang.hm> <1185164357.2714.49.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007, Arjan van de Ven wrote:

> On Sun, 2007-07-22 at 21:04 -0700, david@lang.hm wrote:
>
>>>> this strategy should work well on the normal unpredictable workload that
>>>> most people deal with, but there are some cases where the workload becomes
>>>> pretty predictable (media players for example) where there really is less
>>>> variation, and a need for a constant availability of the cpu, so it may
>>>> actually save a smidge of power to run below the highest freq that the
>>>> voltage allows rather then running faster and being idle more cycles.
>>>
>>> that actually is the example showcase of race-to-idle where you
>>> absolutely want to run at the highest frequency..
>>
>> only if the transitions don't cost anything significant,
>
> these are second order effects though. On a pc, the transition costs are
> quite low (as I said, single or low double digit microseconds).

including pausing all drivers before the transition and unpausing them 
aftrwords?

>> and the
>> computation capacity per watt of power is the same at all frequencies. the
>> chip performance numbers I've been seeing (which I admit are mostly
>> embedded datasheets) indicate that neither of these hold true.
>
> let me give you a real world example then, and the numbers I'm using are
> ballpark the same as you'll find in a (mobile) core 2 duo datasheet, I
> just rounded them a little so that the math works out nice.
>
> power at full speed: 34W
> power at half speed: 24W
> power at idle: 1W

are these numbers for the CPU itself or for the a larger chunk? I could 
easily see these numbers for motherboard (including CPU and RAM), but it 
would surprise me if these numbers are for the CPU itself. I'm used to 
seeing datasheets that have a much more linear voltage/freq (and therefor 
a quadratic voltage/power) curve. in some cases the voltage requirements 
drop faster then the frequency.

> assume media playback, and a dumb one, that takes half a second to
> decode a second of media. (again to make the math simple)
>
> at half speed: Energy for a second is 0.5 * 24 + 0.5 * 1 = 12.5 J
> at full speed: Energy for a second is 0.25 * 34 + 0.75 * 1 = 9.25 J
>
> this works for all systems where the idle power is more lower than the
> power you save by dropping speed... and that is almost all of them in
> the PC world.

if you can idle the system as a whole I agree with you fully. most PC 
hardware (including the mobile stuff) doesn't change it's power 
consumption much with load. at Usenix there was a presentiation (I don't 
remember if it was by Amazon or Google) about this subject, showing that 
current PC hardware only goes down to 50% power when idle (short of 
switching power modes) and that they and other big companies were pushing 
vendors to improve their hardware, aiming to get the idle power down to 
10% (again without suspending anything). so there's some chance that this 
will change before too long.

> now you can argue that 0.5 seconds is a really really long time, and
> you'd be right. so for really really short stints (say a timer
> interrupt) you don't want to change the voltage at all (nor would you
> want to change the plls to change frequency for that matter). But once
> you start chaning those, you might as well go full speed.

this assumes that you can cache 1 second of video, if you have more 
real-time requirements you have a much harder time (say video confrancing 
where you don't get the frame until just before you need to display it)

David Lang

