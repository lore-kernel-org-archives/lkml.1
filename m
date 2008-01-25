Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYAYO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYAYO6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbYAYO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:58:16 -0500
Received: from kunder.interhost.no ([80.239.54.98]:36634 "EHLO
	kunder.interhost.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbYAYO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:58:15 -0500
X-Greylist: delayed 1623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 09:58:15 EST
Message-ID: <4799F2D7.5060504@sannes.org>
Date: Fri, 25 Jan 2008 15:31:51 +0100
From: =?ISO-8859-1?Q?Asbj=F8rn_Sannes?= <ace@sannes.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071217)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unpredictable performance
References: <4799C8E8.9060501@ifi.uio.no> <200801260100.24597.nickpiggin@yahoo.com.au>
In-Reply-To: <200801260100.24597.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 25 January 2008 22:32, Asbjorn Sannes wrote:
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
>
> Hmm, lots of things could cause it. With such big variations in
> elapsed time, and small variations on CPU time, I guess the fs/IO
> layers are the prime suspects, although it could also involve the
> VM if you are doing a fair amount of page reclaim.
>
> Can you boot with enough memory such that it never enters page
> reclaim? `grep scan /proc/vmstat` to check.
>
> Otherwise you could mount the working directory as tmpfs to
> eliminate IO.
>
> bisecting it down to a single patch would be really helpful if you
> can spare the time.
>   
I'm going to run some tests without limiting the memory to 80 megabytes
(so that it is 2 gigabyte) and see how much it varies then, but iff I
recall correctly it did not vary much. I'll reply to this e-mail with
the results.

I can do some bisecting next week and see if I find any, but it will
probably take a lot of time considering that I need to do enough runs..
how much should this vary anyways? The kernel is compiled as an UP
kernel and there is nothing running in parallel with it.. it is
basically a .sh script running on boot appending the output of time to a
file .. formatting and rebooting.

--
Asbjørn Sannes

