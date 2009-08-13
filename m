Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZHMP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZHMP6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZHMP6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:58:12 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56946 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZHMP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:58:11 -0400
Date: Thu, 13 Aug 2009 17:58:12 +0200
From: Andreas Mohr <andi@lisas.de>
To: Marton Balint <cus@fazekas.hu>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org, mingo@elte.hu,
       peterz@infradead.org
Subject: Re: CPU scheduler weirdness?
Message-ID: <20090813155812.GA15714@rhlx01.hs-esslingen.de>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 13, 2009 at 05:39:10PM +0200, Marton Balint wrote:
>>> Does anybody have any idea what can cause this?
>>
>> /sys/devices/system/cpu/sched_smt_power_savings , perhaps?
>
> Thanks for the tip, tuning the sched_mc_power_savings setting helped! The 
> original value of it was 0, but after setting it to 1, the two  
> cpu-intensive processes got scheduled to different CPU cores, as 
> expected.

Heh, I did expect it to not help, and indeed that thing helping in this
way points to a... BUG, plain and simple.

http://lwn.net/Articles/297306/
lists possible settings as

"
The power savings and performance of the given workload in an under
utilised system can be controlled by setting values of 0, 1 or 2 to
/sys/devices/system/cpu/sched_mc_power_savings with 0 being highest
performance and least power savings and level 2 indicating maximum
power savings even at the cost of slight performance degradation.
"

which is exactly opposite to what I'd have expected to be normal,
unconfigured behaviour in your case.

> Setting it back to 0 casused the two cpu-intensive processes to run on  
> the same CPU again. So I guess I will just set it to 1 after booting the  
> system.

...which would indicate a level=1 or level=2 (maximum powersaving)
behaviour. Something either seems reversed or really weird.
But it could just be opaque if correct behaviour due to a much more complex
load balancing algo in the scheduler or so.

Comments, anyone?

Andreas Mohr
