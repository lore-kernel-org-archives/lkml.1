Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319Ab0A3T0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0A3T0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0A3T0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:26:39 -0500
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:64121 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0A3T0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:26:38 -0500
Date: Sat, 30 Jan 2010 14:26:51 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Regression: hung task during raid rebuild 2.6.33 rc5 was: Re:
 2.6.33RC3 hung task - jbd2/dm-1-8 (during raid rebuild)
In-reply-to: <4B6486A7.8030404@majjas.com>
To: linux-kernel@vger.kernel.org
Message-id: <4B6487FB.2010508@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B4A4AD7.5090800@majjas.com> <4B6486A7.8030404@majjas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2010 2:21 PM, Michael Breuer wrote:
> On 1/10/2010 4:47 PM, Michael Breuer wrote:
>> System crashed (watchdog reset).
>>
>> Was doing a raid rebuild at the time (raid6).
>>
>> I typed, 'yumdownloader --source virtlib' ... system froze, then 
>> rebooted on the watchdog reset.
>>
>> I've attached the log extract from the event as well as dmesg.
>>
>>
> Hit this again - system doesn't crash now - just get the hung task 
> warning (log extract attached). System seems to keep running (albeit 
> the rebuild is incredibly slow on 2.6.33 rc5 - approx 6500K/sec vs. 
> about 80,000K/sec on 2.6.32.4.
>
> Looks like it may be triggered by disk io during the rebuild. This 
> time I had typed, "sync." "sync" hung for a long while but did 
> eventually complete.
Also - when I attempted to reboot, I got the following (only on an ssh 
terminal window - nothing in dmesg or log after reboot):

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:------------[ cut here ]------------

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:invalid opcode: 0000 [#1] SMP

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:last sysfs file: /sys/devices/virtual/block/md0/size

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:Stack:

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:Call Trace:

Message from syslogd@mail at Jan 30 14:16:42 ...
  kernel:Code: 41 5f c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 38 0f 1f 
44 00 00 48 89 fb f6 46 20 01 0f 84 26 01 00 00 8b 47 38 83 f8 01 75 04 
<0f> 0b eb fe 45 31 e4 83 f8 02 75 2a c7 47 38 00 00 00 00 f0 80

[ends here]
