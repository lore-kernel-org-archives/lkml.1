Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXETAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXETAok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXETAod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:44:33 -0400
Received: from pool-72-92-171-78.albyny.east.verizon.net ([72.92.171.78]:50421
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755763AbXETAod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:44:33 -0400
Message-ID: <464F99EC.3080006@tmr.com>
Date: Sat, 19 May 2007 20:44:28 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Ray Lee <ray@madrabbit.org>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com>
In-Reply-To: <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 5/19/07, Bill Davidsen <davidsen@tmr.com> wrote:
>> I generated a table of results from the latest glitch1 script, using an
>> HTML postprocessor I not *quite* ready to foist on the word. In any case
>> it has some numbers for frames per second, fairness of the processor
>> time allocated to the compute bound processes which generate a lot of
>> other screen activity for X, and my subjective comments on how smooth it
>> looked and felt.
>>
>> The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for
>> your viewing pleasure.
> 
> Is the S.D. columns (immediately after the average) standard
> deviation? If so, you may want to rename those 'stdev', as it's a
> little confusing to have S.D. stand for that and Staircase Deadline.
> Further, which standard deviation is it? (The standard deviation of
> the values (stdev), or the standard deviation of the mean (sdom)?)
> 
What's intended is the stddev from the average, and perl bit me on that 
one. If you spell a variable wrong the same way more than once it 
doesn't flag it as a possible spelling error.

Note on the math, even when coded as intended, the divide of the squares 
of the errors is by N-1 not N. I found it both ways in online doc, but I 
learned it decades ago as "N-1" so I used that.
> Finally, if it is the standard deviation (of either), then I don't
> really believe those numbers for the glxgears case. The deviation is
> huge for all but one of those results.
> 
I had the same feeling, but because of the code error above, what failed 
was zeroing the sum of the errors, so (a) values after the first kept 
getting larger, and when I debugged it against the calculation by hand, 
the first one matched so I thought I had it right.

> Regardless, it's good that you're doing measurements, and keep it up :-).

Okay, here's a bonus, http://www.tmr.com/~davidsen/sched_smooth_02.html 
not only has the right values, the labels are changed, and I included 
more data points from the fc6 recent kernel and the 2.6.21.1 kernel with 
the mainline scheduler.

The nice thing about this test and the IPC test I posted recently is 
that they are reasonable stable on the same hardware, so even if someone 
argues about what they show, they show the same thing each time and can 
therefore be used to compare changes.

As I told a manger at the old Prodigy after coding up some log analysis 
with pretty graphs, "getting the data was the easy part, the hard part 
is figuring out what it means." If this data is useful in suggesting 
changes, then it has value. Otherwise it was a fun way to spend some time.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
