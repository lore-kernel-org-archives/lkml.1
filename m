Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbXGKS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbXGKS7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554AbXGKS7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:59:17 -0400
Received: from smtp50.hccnet.nl ([62.251.0.47]:38563 "EHLO smtp50.hccnet.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbXGKS7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:59:15 -0400
Message-ID: <469528A5.6040605@hccnet.nl>
Date: Wed, 11 Jul 2007 20:59:49 +0200
From: Gert Vervoort <gert.vervoort@hccnet.nl>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22: dvb header files break compilation on x86-64
References: <4691F8D6.30600@hccnet.nl> <20070711160254.GH3492@stusta.de>
In-Reply-To: <20070711160254.GH3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jul 09, 2007 at 10:59:02AM +0200, Gert Vervoort wrote:
>   
>> Some of the linux/dvb header files include libc header files and break 
>> compilation on x86-64 in compat_ioctl.c:
>>
>>
>>   CC      fs/timerfd.o
>>   CC      fs/eventfd.o
>>   CC      fs/compat.o
>>   CC      fs/compat_ioctl.o
>> In file included from fs/compat_ioctl.c:111:
>> include/linux/dvb/audio.h:27:20: error: stdint.h: No such file or directory
>> In file included from fs/compat_ioctl.c:112:
>> include/linux/dvb/dmx.h:28:18: error: time.h: No such file or directory
>> make[1]: *** [fs/compat_ioctl.o] Error 1
>> make: *** [fs] Error 2
>> [root@apollo linux-2.6.x]#
>>     
>
> According to the line numbers your build is pulling a version of the 
> header cleaned for userspace.
>
> Does this happen with a freshly unpacked vanilla 2.6.22 kernel from 
> ftp.kernel.org?
>
>   
Indeed, it seems that these files, in the kernel tree I used with the 
2.6.22 patch, where modified in the past (a diff of 
include/linux/dvb/audio.h between my tree and a fresh tree clearly 
showed the problem).

I replaced my tree with a fresh 2.6.22 tree and it now compiles without 
any problems.

   Gert


> Please send the first 50 lines of the file include/linux/dvb/audio.h in 
> your kernel sources.
>
> What is the output of "make V==1" for fs/compat_ioctl.o?
>
>   
>>    Gert
>>     
>
> cu
> Adrian
>
>   

