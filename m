Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXFBI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXFBI5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXFBI5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:57:36 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:52006 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbXFBI5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:57:35 -0400
Message-ID: <466131CB.20301@free.fr>
Date: Sat, 02 Jun 2007 11:00:59 +0200
From: Thierry Merle <thierry.merle@free.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	 <1180364420.21547.160.camel@localhost>	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>	 <1180378677.21547.189.camel@localhost>	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>	 <465BBAFB.30906@free.fr> <1180448712.21547.314.camel@localhost>	 <465C7920.2080203@free.fr> <1180467116.9509.73.camel@localhost>	 <465F3361.106@free.fr> <1180739401.3904.50.camel@localhost>
In-Reply-To: <1180739401.3904.50.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mauro Carvalho Chehab a écrit :
>>> This seems to be an interesting approach.
>>>
>>>   
>>>       
>> Interesting but impossible to do for ioctl calls.
>> When the application does a ioctl(fd_of_mnt_video0,VIDIOC_G_FMT,&arg) 
>> for example, there is no way for the userspace helper to catch this ioctl.
>> The application could only open/read from the userspace helper's file 
>> /mnt/video0.
>> ioctl would still have to be done on the kernel device driver.
>> I thought also about a /proc interface for decompression algorithms (a 
>> helper would listen on a /proc file and write on another /proc file) but 
>> /proc is not designed for that kind of thing.
>> A separate library seems to be the simplest solution.
>>     
>
> There are some ways for this to work. For example, you may create a
> helper device for the daemon driver to bind, even requiring it to have
> root permission.
>
>   
Right, but I am afraid that complex userspace/kernelspace context 
changes breaks performance.
Nevertheless, I will start to specify the framework.
The helper daemon would link to the v4l2-apps/lib.
