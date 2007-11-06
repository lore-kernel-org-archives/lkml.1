Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXKFMVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXKFMVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbXKFMVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:21:04 -0500
Received: from rayleigh.systella.fr ([213.41.184.253]:34879 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbXKFMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:21:02 -0500
Message-ID: <47305C1D.5070500@systella.fr>
Date: Tue, 06 Nov 2007 13:20:45 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>  <18222.16003.92062.970530@notabene.brown>  <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>  <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>  <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan> <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com> <47303FB8.7000801@systella.fr> <Pine.LNX.4.64.0711060628450.3010@p34.internal.lan> <47305288.8020307@systella.fr> <Pine.LNX.4.64.0711060641210.3010@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0711060641210.3010@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Tue, 06 Nov 2007 13:20:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Tue, 6 Nov 2007, BERTRAND Joël wrote:
> 
>> Justin Piszcz wrote:
>>>
>>>
>>> On Tue, 6 Nov 2007, BERTRAND Joël wrote:
>>>
>>>>     Done. Here is obtained ouput :
>>>>
>>>> [ 1265.899068] check 4: state 0x6 toread 0000000000000000 read 
>>>> 0000000000000000 write fffff800fdd4e360 written 0000000000000000
>>>> [ 1265.941328] check 3: state 0x1 toread 0000000000000000 read 
>>>> 0000000000000000 write 0000000000000000 written 0000000000000000
>>>> [ 1265.972129] check 2: state 0x1 toread 0000000000000000 read 
>>>> 0000000000000000 write 0000000000000000 written 0000000000000000
>>>>
>>>>
>>>>     For information, after crash, I have :
>>>>
>>>> Root poulenc:[/sys/block] > cat /proc/mdstat
>>>> Personalities : [raid1] [raid6] [raid5] [raid4]
>>>> md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
>>>>      1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>>>
>>>>     Regards,
>>>>
>>>>     JKB
>>>
>>> After the crash it is not 'resyncing' ?
>>
>>     No, it isn't...
>>
>>     JKB
>>
> 
> After any crash/unclean shutdown the RAID should resync, if it doesn't, 
> that's not good, I'd suggest running a raid check.
> 
> The 'repair' is supposed to clean it, in some cases (md0=swap) it gets 
> dirty again.
> 
> Tue May  8 09:19:54 EDT 2007: Executing RAID health check for /dev/md0...
> Tue May  8 09:19:55 EDT 2007: Executing RAID health check for /dev/md1...
> Tue May  8 09:19:56 EDT 2007: Executing RAID health check for /dev/md2...
> Tue May  8 09:19:57 EDT 2007: Executing RAID health check for /dev/md3...
> Tue May  8 10:09:58 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
> Tue May  8 10:09:58 EDT 2007: 2176
> Tue May  8 10:09:58 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
> Tue May  8 10:09:58 EDT 2007: 0
> Tue May  8 10:09:58 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Tue May  8 10:09:58 EDT 2007: 0
> Tue May  8 10:09:58 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
> Tue May  8 10:09:58 EDT 2007: 0
> Tue May  8 10:09:58 EDT 2007: The meta-device /dev/md0 has 2176 
> mismatched sectors.
> Tue May  8 10:09:58 EDT 2007: Executing repair on /dev/md0
> Tue May  8 10:09:59 EDT 2007: The meta-device /dev/md1 has no mismatched 
> sectors.
> Tue May  8 10:10:00 EDT 2007: The meta-device /dev/md2 has no mismatched 
> sectors.
> Tue May  8 10:10:01 EDT 2007: The meta-device /dev/md3 has no mismatched 
> sectors.
> Tue May  8 10:20:02 EDT 2007: All devices are clean...
> Tue May  8 10:20:02 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
> Tue May  8 10:20:02 EDT 2007: 2176
> Tue May  8 10:20:02 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
> Tue May  8 10:20:02 EDT 2007: 0
> Tue May  8 10:20:02 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Tue May  8 10:20:02 EDT 2007: 0
> Tue May  8 10:20:02 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
> Tue May  8 10:20:02 EDT 2007: 0

	I cannot repair this raid volume. I cannot reboot server without 
sending stop+A. init 6 stops at "INIT:". After reboot, md0 is 
resynchronized.

	Regards,

	JKB
