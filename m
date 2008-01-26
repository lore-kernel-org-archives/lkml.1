Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYAZRMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYAZRMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 12:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYAZRLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 12:11:54 -0500
Received: from mail.syneticon.net ([213.239.212.131]:47939 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYAZRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 12:11:53 -0500
Message-ID: <479B69D2.5050603@wpkg.org>
Date: Sat, 26 Jan 2008 18:11:46 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: toralf.foerster@gmx.de
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:

> I use a 1-liner for a simple performance check : "time factor 819734028463158891"
> Here is the result for the new (Gentoo) kernel 2.6.24:
> 
> With the  ondemand governor of the  I get:
> 
> tfoerste@n22 ~/tmp $ time factor 819734028463158891
> 819734028463158891: 3 273244676154386297
> 
> real    0m32.997s
> user    0m15.732s
> sys     0m0.014s
> 
> With the ondemand governor the CPU runs at 600 MHz,
> whereas with the performance governor I get :
> 
> tfoerste@n22 ~/tmp $ time factor 819734028463158891
> 819734028463158891: 3 273244676154386297
> 
> real    0m10.893s
> user    0m5.444s
> sys     0m0.000s
> 
> (~5.5 sec as I expected) b/c the CPU is set to 1.7 GHz.
> 
> The ondeman governor of previous kernel versions however automatically increased
> the CPU speed from 600 MHz to 1.7 GHz.
> 
> My system is a ThinkPad T41, I'll attach the .config 

During the test, run top, and watch your CPU usage. Does it go above 80% 
(the default for 
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold).

ondemand CPUfreq governor has a few tunables, described in 
Documentation/cpu-freq. One of them is up_threshold:

up_threshold: defines what the average CPU usaged between the samplings
of 'sampling_rate' needs to be for the kernel to make a decision on
whether it should increase the frequency. For example when it is set
to its default value of '80' it means that between the checking
intervals the CPU needs to be on average more than 80% in use to then
decide that the CPU frequency needs to be increased.

What CPUFreq processor driver are you using?


I had a similar problem with CPUfreq and dm-crypt (slow reads), see 
(more setup problem than something kernel-related):

http://blog.wpkg.org/2008/01/22/cpufreq-and-dm-crypt-performance-problems/


-- 
Tomasz Chmielewski
