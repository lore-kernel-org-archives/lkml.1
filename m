Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYHUSok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYHUSok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHUSoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:44:32 -0400
Received: from mx06.lb01.inode.at ([62.99.145.6]:15942 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbYHUSob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:44:31 -0400
Message-ID: <48ADB77F.9060301@sbg.ac.at>
Date: Thu, 21 Aug 2008 20:44:15 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (X11/20080729)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work
References: <4899AF8E.20105@sbg.ac.at>	 <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>	 <489B73B7.4090705@sbg.ac.at>	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>	 <489B85A3.7030500@sbg.ac.at>	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>	 <48A43CB5.8010709@sbg.ac.at>	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>	 <48AD8125.7050104@sbg.ac.at> <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
In-Reply-To: <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Aug 21, 2008 at 7:52 AM, Alexander Huemer
> <alexander.huemer@sbg.ac.at> wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> On Thu, Aug 14, 2008 at 7:09 AM, Alexander Huemer
>>> <alexander.huemer@sbg.ac.at> wrote:
>>>
>>>       
>>>> Yinghai Lu wrote:
>>>>
>>>>         
>>>>> On Thu, Aug 7, 2008 at 4:30 PM, Alexander Huemer
>>>>> <alexander.huemer@sbg.ac.at> wrote:
>>>>>
>>>>>
>>>>>           
>>>>>> Yinghai Lu wrote:
>>>>>>
>>>>>>
>>>>>>             
>>>>>           
>>>>>>>> can you put "debug" in command line too?
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>                 
>>>>>>> without mtrr_chunk_size etc in command line...please
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>               
>>>>>> http://xx.vu/~ahuemer/dmesg_3.txt
>>>>>>
>>>>>>
>>>>>>
>>>>>>             
>>>>> do you have
>>>>> CONFIG_MTRR=y
>>>>> CONFIG_MTRR_SANITIZER=y
>>>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>>>>
>>>>> in your .config?
>>>>>
>>>>> YH
>>>>>
>>>>>
>>>>>           
>>>> 2.6.27_rc3 does not solve the problem either.
>>>> what can i do to help?
>>>>
>>>>         
>>> please send out you config
>>>
>>> YH
>>>
>>>       
>> yinghai,
>>
>> i just tried out 2.6.27-rc4, unfortunately without success.
>>
>> here are my settings again,
>> if you need more info, just tell me.
>>
>> as you can see, the mtrr size values are complete nonsense.
>> the framebuffer should be at d8000000.
>> i am unsure if this is the fault of the kernel or the bios.
>> or should the MTRR_SANITIZER resolv all broken bios issues?
>>
>>   # uname -a
>>   Linux seaburg 2.6.27-rc4-blackbit #1 SMP Thu Aug 21 15:53:38 CEST
>>   2008 x86_64 Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux
>>   # grep -E "(^\(WW\)|^\(EE\)|^\(NI\)|^\(??\))" /var/log/Xorg.0.log
>>   (WW) VESA(0): Failed to set up write-combining range
>>   (0xd8000000,0x2000000)
>>   # dmesg|grep mtrr                                                 Command
>> line: root=/dev/sda1
>>   video=uvesafb:1280x1024-24@97,mtrr:3,ywrap mtrr_chunk_size=512m
>>   Kernel command line: root=/dev/sda1
>>   video=uvesafb:1280x1024-24@97,mtrr:3,ywrap mtrr_chunk_size=512m
>>     
>
> please boot without mtrr_chunk_size=512m
> and put debug in your command line
>
>
>   
>>   # cat /proc/mtrr
>>   reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
>>   reg01: base=0x80000000 (2048MB), size=197632MB: write-back, count=1
>>   reg02: base=0x100000000 (4096MB), size=197632MB: write-back, count=1
>>     
>
> another case of crazy size in /proc/mtrr
>
> it is E5420, maybe mtrr code has problem to handle that cpu?
>
> YH
>   
yinghai,

i booted as you suggested. i cannot see any difference.
here is the dmesg output: http://xx.vu/~ahuemer/dmesg_4.txt

what else can i do?

-- 
thanks
alex
