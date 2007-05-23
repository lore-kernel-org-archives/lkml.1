Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbXEWNJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbXEWNJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXEWNJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:09:29 -0400
Received: from mail.tmr.com ([64.65.253.246]:44571 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbXEWNJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:09:28 -0400
Message-ID: <46543D3A.9030805@tmr.com>
Date: Wed, 23 May 2007 09:10:18 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Miguel Figueiredo <elmig@debianpt.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org> <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com> <46507E1D.6030002@debianpt.org> <46532E8A.4030900@tmr.com> <46534C31.1060306@debianpt.org> <46538AB8.8030009@tmr.com>
In-Reply-To: <46538AB8.8030009@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was unable to reproduce the numbers Miguel generated, comments below. 
The -ck2 patch seems to run nicely, although the memory repopulation 
from swap would be most useful on system which have a lot of memory 
pressure.

Bill Davidsen wrote:
> Miguel Figueiredo wrote:
>>
>> Hi Bill,
>>
>> if i've understood correctly the script runs glxgears for 43 seconds 
>> and in that time generates random numbers in a random number of times 
>> (processes, fork and forget), is that it?
>>
> No, I haven't made it clear. A known number (default four) of xterms 
> are started, each of which calculates random numbers and prints them, 
> using much CPU time and causing a lot of scrolling. At the same time 
> glxgears is running, and the smoothness (or not) is observed manually. 
> The script records raw data on the number of frames per second and the 
> number of random numbers calculated by each shell. Since these are 
> FAIR schedulers, the variance between the scripts, and between 
> multiple samples from glxgears is of interest. To avoid startup 
> effects the glxgears value from the first sample is reported 
> separately and not included in the statistics.
>
> I looked at your results, and they are disturbing to say the least, it 
> appears that using the ck2 scheduler glxgears stopped for all 
> practical purposes. You don't have quite the latest glitch1, the new 
> one runs longer and allows reruns to get several datasets, but the 
> results still show very slow gears and a large difference between the 
> work done by the four shells. That's not a good result, how did the 
> system feel?
>> You find the data, for 2.6.21-{cfs-v13, ck2} in 
>> http://www.debianpt.org/~elmig/pool/kernel/20070522/
>>
> Thank you, these results are very surprising, and I would not expect 
> the system to be pleasing the use under load, based on this.
>> Here's the funny part...
>>
>> Lets call:
>>
>> a) to "random number of processes run while glxgears is running", 
>> gl_fairloops file
>>
> It's really the relative work done by identical processes, hopefully 
> they are all nearly the same, magnitude is interesting but related to 
> responsiveness rather than fairness.
>> b) to "generated frames while running a burst of processes" aka 
>> "massive and uknown amount of operations in one process", gl_gears file
>>
> Well, top or ps will give you a good idea of processing, but it tried 
> to use all of one CPU if allowed. Again, similarity of samples 
> reflects fairness and magnitude reflects work done.
>> kernel    2.6.21-cfs-v13    2.6.21-ck2
>> a)    194464        254669       b)    54159        124
>>
>>
> Everyone seems to like ck2, this makes it look as if the video display 
> would be really pretty unusable. While sd-0.48 does show an occasional 
> video glitch when watching video under heavy load, it's annoying 
> rather than unusable.
>
I spent a few hours running the -ck2 patch, and I didn't see any numbers 
like yours. What I did see is going up with my previous results as 
http://www.tmr.com/~davidsen/sched_smooth_04.html. While there were 
still some minor pauses in glxgears with my test, performance was very 
similar to the sd-0.48 results. And I did try watching video with high 
load, without problems. Only when I run a lot of other screen-changing 
processes can I see pauses in the display.
> Your subjective impressions would be helpful, and you may find that 
> the package in the www.tmr.com/~public/source is slightly easier to 
> use and gives more stable results. The documentation suggests the way 
> to take samples (the way I did it) but if you feel more or longer 
> samples would help it is tunable.
>
> I added Con to the cc list, he may have comments or suggestions 
> (against the current versions, please). Or he may feel that video 
> combined with other heavy screen updating is unrealistic or not his 
> chosen load. I'm told the load is similar to games which use threads 
> and do lots of independent action, if that's a reference.
>
I'll include the -ck2 patch in my testing on other hardware.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

