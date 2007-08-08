Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXHHWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXHHWEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXHHWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:04:41 -0400
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:58557 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbXHHWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:04:40 -0400
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e39372e36347c3149497464752d3030303458482d50617c3131383636313036
	3738
Message-ID: <46BA3DF5.4050201@snafu.de>
Date: Thu, 09 Aug 2007 00:04:37 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange> <46BA320E.1030608@snafu.de> <Pine.LNX.4.60.0708082323420.6767@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708082323420.6767@poirot.grange>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Wed, 8 Aug 2007, Oncaphillis wrote:
> 
>>  So that's ok ? No misconfiguration ? And that setserial tells
>>  me the port is 0x000 ?
> 
> Yes, everything looks ok, don't know why, setserial reports 0 here too, 
> but it doesn't cause me any (visible) problems.
> 
>>  I thought the dts file which
>>  comes with the linkstation kernel describes the ports and IRQs
>>  but poking there didn't change anything. It seems like the kernel
>>  is ignoring the serial settings in the dts-file (which I do not
>>  realy understand) all together.
> 
> Believe me, it doesn't ignore them:-) Don't know what exactly you were 
> poking at there, but it should be quite easy to break it by changing 
> clocks / address / irq...
> 
>>   I started with a debian distro
>>   http://www.kurobox.com/mwiki/index.php/Debian_sylver
>>
>>   Hmm I tried my very best to eliminate this everywhere. Actually I
>>   resurrected the ARV00 device by creating a soft link to a ttySx
>>   with during bootup within the udev filesystem.
>>
>>   <snip>
>>         if [ ! -e /dev/AVR00 ];then
>>          cat /proc/tty/driver/serial | grep 80004500 | grep -q 0:
>>            && AVR=/dev/ttyS0 || AVR=/dev/ttyS1
>>          echo "Making AVR00 link to "$AVR;
>>          ln -s $AVR /dev/AVR00
>>         fi;
>>   </snip>
>>
>> Stole the trick from the avr_evtd startup script...
> 
> Well, just do "ls -l /dev/AVR00", then "lsof /dev/ttyS0".
> 

   Oh.... that's something I should have thought about (shaking my
   head)

   I hope I found the the misconfigured part. I didn't look
   at /etc/inittab. It opens a getty on /dev/ttyS0. That
   might do the trick. Have to recompile my kernel right now with
   standard config to check this out.

> In principle, as mentioned elsewhere before, you don't need any daemons on 
> linkstation/kurobox now for "basic" operation, i.e., the kernel disables 
> the watchdog on startup, and properly sends reboot and power-off commands 
> to the AVR itself without any userspace support. So, at least for a test, 
> you could stop all those daemons. You need them though if you want to use 
> the buttons to power down / reboot / whatever, do other fancy things with 
> the AVR...

   Well ... it doesn't seem to need the daemons but at least
   the kuro_boot  script or something similar has to be executed
   once sending the right init strings to the AVR or your system
   reboots after a few minutes at least on my box.

> Another possible reason why, for example, your stty misbehaves, maybe it 
> is somehow broken in that distro? I am just using etch and things work 
> pretty well.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski

