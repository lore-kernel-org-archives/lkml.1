Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbYAYUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbYAYUua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYAYUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:50:24 -0500
Received: from kunder.interhost.no ([80.239.54.98]:59190 "EHLO
	kunder.interhost.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbYAYUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:50:23 -0500
Message-ID: <479A4B6E.9070607@sannes.org>
Date: Fri, 25 Jan 2008 21:49:50 +0100
From: =?ISO-8859-1?Q?Asbj=F8rn_Sannes?= <ace@sannes.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071202)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unpredictable performance
References: <4799C8E8.9060501@ifi.uio.no> <2c0942db0801250916v6b1f988fre454dd7e33d7985@mail.gmail.com>
In-Reply-To: <2c0942db0801250916v6b1f988fre454dd7e33d7985@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Jan 25, 2008 3:32 AM, Asbjorn Sannes <asbjorsa@ifi.uio.no> wrote:
>   
>> Hi,
>>
>> I am experiencing unpredictable results with the following test
>> without other processes running (exception is udev, I believe):
>> cd /usr/src/test
>> tar -jxf ../linux-2.6.22.12
>> cp ../working-config linux-2.6.22.12/.config
>> cd linux-2.6.22.12
>> make oldconfig
>> time make -j3 > /dev/null # This is what I note down as a "test" result
>> cd /usr/src ; umount /usr/src/test ; mkfs.ext3 /dev/cc/test
>> and then reboot
>>
>> The kernel is booted with the parameter mem=81920000
>>
>> For 2.6.23.14 the results vary from (real time) 33m30.551s to 45m32.703s
>> (30 runs)
>> For 2.6.23.14 with nop i/o scheduler from 29m8.827s to 55m36.744s (24 runs)
>> For 2.6.22.14 also varied a lot.. but, lost results :(
>> For 2.6.20.21 only vary from 34m32.054s to 38m1.928s (10 runs)
>>
>> Any idea of what can cause this? I have tried to make the runs as equal
>> as possible, rebooting between each run.. i/o scheduler is cfq as default.
>>
>> sys and user time only varies a couple of seconds.. and the order of
>> when it is "fast" and when it is "slow" is completly random, but it
>> seems that the results are mostly concentrated around the mean.
>>     
.. I may have jumped the gun a "little" early saying that it is mostly 
concentrated around the mean, grepping from memory is not always .. hm, 
accurate :P
>
> First off, not all tests are good tests. In particular, small timing
> differences can get magnified horrendously by heading into swap.
>
>   
So, what you are saying is that it is expected to vary this much under 
memory pressure? That I can not do anything with this on real hardware?
> That said, do you have the means and standard deviations of those
> runs? That's a good way to tell whether the tests are converging or
> not, and whether your results are telling you anything.
>
>   
I have all the numbers, I was just hoping that there was a way to 
benchmark a small change without a lot of runs. It seems to me to quite 
randomly distributed .. from the 2.6.23.14 runs:
43m10.022s, 34m31.104s, 43m47.221s, 41m17.840s, 34m15.454s,
37m54.327s, 35m6.193s, 38m16.909s, 37m45.411s, 40m13.169s
38m17.414s, 34m37.561s, 43m18.181s, 35m46.233s, 34m44.414s,
39m55.257s, 35m28.477s, 33m30.551s, 41m36.394s, 43m6.359s,
42m42.396s, 37m44.293s, 41m6.615s, 35m43.084s, 39m25.846s,
34m23.753s, 36m0.556s, 41m38.095s, 45m32.703s, 36m18.325s,
42m4.840s, 43m53.759s, 35m51.138s, 40m19.001s

Say I made a histogram of this (tilt your head :P) with 1 minute intervals:
33 *
34 *****
35 *****
36 **
37 ***
38 **
39 **
40 **
41 ****
42 **
43 *****
44
45 *

I don't really know what to make of that.. Going to see what happens 
with less memory and make -j1, perhaps it will be more stable.
> Also as you're on a uniprocessor system, make -j2 is probably going to
> be faster than make -j3. Perhaps immaterial to whatever you're trying
> to test, but there you go.
Yes, I was hoping to have a more deterministic test to get a higher 
confidence in fewer runs when testing changes. Especially under memory 
pressure. And I truly was not expecting this much fluctuations, which is 
why I tested several kernel versions to see if this influenced it and 
mailed lkml. The computer is actually a dual core amd processor, but I 
compiled the kernel with no smp to see if that helped on the dispersion.

--
Asbjorn Sannes



