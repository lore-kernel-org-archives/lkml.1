Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYEHNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYEHNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYEHNQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:16:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:31432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYEHNQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="562247806"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 8 May 2008 06:18:48 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE01005A16@orsmsx423.amr.corp.intel.com>
In-reply-to: <4822A6F7.7010704@numericable.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Thread-Index: Aciw2lnn6z7Te9CwQnCVtA3XGHkhawAMV0OA
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr> <20080505232536.GA28026@linux-os.sc.intel.com> <20080505234938.GB11433@elte.hu> <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
X-OriginalArrivalTime: 08 May 2008 13:16:12.0979 (UTC) FILETIME=[B040D830:01C8B10D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>Sent: Thursday, May 08, 2008 12:09 AM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>xf86MapVidMem error
>
>Pallipadi, Venkatesh a écrit :
>>  
>>
>>   
>>> -----Original Message-----
>>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr] 
>>> Sent: Wednesday, May 07, 2008 1:58 PM
>>> To: Pallipadi, Venkatesh
>>> Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>>> Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>>> xf86MapVidMem error
>>>
>>> Pallipadi, Venkatesh a écrit :
>>>     
>>>>  
>>>>
>>>> Yes. This has some debug information in there. Did you see 
>>>>       
>>> xf86MapVidMem error (I mean did you try to start X) before you 
>>> captured this dmesg?
>>>     
>>>> Thanks,
>>>> Venki
>>>>
>>>>   
>>>>       
>>> Hi all,
>>>
>>> Yes, the error's message is in my Xorg.log file :-)
>>>
>>>     
>>
>> One more piece of data I need. Can you please send the 
>output of `cat /proc/mtrr` from this system (after the X 
>failure has happened)
>>
>> Thanks,
>> Venki
>>
>>   
>Hi Venki,
>
>
>See my /proc/mtrr file attached.
>

OK. Thanks for all the info.

I think I figured out what is going wrong here:
1) uvesafb is mapping 0xf0000000-0xf1000000
[4294014.924303] reserve_memtype added 0xf0000000-0xf1000000, track uncached-minus, req uncached-minus, ret uncached-minus

2) Set up the framebuffer within that mapped region. Uvesafb is setting "write-combine" mtrr for framebuffer for this 16M. 0xf0000000-0xf1000000
[4294015.649340] uvesafb: framebuffer at 0xf0000000, mapped to 0xffffc20010a80000, using 16384k, total 16384k
[4294015.649340] fb0: VESA VGA frame buffer device

3) Later when X starts up, it tries to map bigger PCI range 0xf0000000-0xf8000000 from /dev/mem.

4) PAT check tries to make sure the entire region being mmap'ed is of the same effective memory type. But in this case start of the address (0xf0000000) is write-combine and end of the address is uncached. So, with the new PAT code mmap fails with EINVAL, resulting in X failure.
xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid argument)


Now we need to figure out a clean solution for this problem. I think we don't have to check the full range of address is of same type as long as we are requesting for PAT type UC_MINUS and MTRR has WC sub ranges. But, we need to think about other such conflict conditiond when having multiple users of same range (uvesafb and X) also. Will be back with a patch for you to try and test.

Thanks,
Venki
