Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXE2TAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXE2TAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXE2TAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:00:45 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:54672 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXE2TAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:00:45 -0400
Message-ID: <465C7920.2080203@free.fr>
Date: Tue, 29 May 2007 21:04:00 +0200
From: Thierry Merle <thierry.merle@free.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	 <1180364420.21547.160.camel@localhost>	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>	 <1180378677.21547.189.camel@localhost>	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>	 <1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>	 <465BBAFB.30906@free.fr> <1180448712.21547.314.camel@localhost>
In-Reply-To: <1180448712.21547.314.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Mauro Carvalho Chehab a écrit :
>   
>   
>>> Hi Mauro and Markus,
>>> Just to summ up what I understood we need:
>>>
>>> What do we need in userspace, only for v4l (dvb is not concerned):
>>> - colorspace translations
>>> - filters that be done in hardware if the selected hardware can, 
>>> otherwise software plugin
>>> - decompression algorithm like stk11xx or usbvision (the decompression 
>>> algorithm is in kernelspace since it is of linear complexity but shall 
>>> be moved to userspace)
>>>       
>
> Yes. The first focus, IMO, should be the last one.
>
>   

OK, so we must open the V4L2 API to add a custom pixel format.
While brainstorming, I thought it would be funny to create userspace 
drivers like FUSE based projects do.
Applications would see nothing but a new device driver to access, all 
decompression algorithm would be in userspace.
The path from the application to the v4l2 kernel driver:
[Application]<->[/mnt/video0 (created by FUSE-like userspace 
lib)]<->[/dev/video0 (created by kernel v4l2 driver)]
There are limitations that I don't know, but this would be transparent 
for the applications.

>>> Using pwlib will not mean that application developers will use pwlib 
>>> to decode v4l driver outputs.
>>> C bindings are much more popular than C++ bindings and do not prevent 
>>> object oriented design.
>>>       
>
> IMO, we should implement very simple and efficient C subroutines.
>
>   
>>> Application developers implement their own codecs.
>>>       
>
> They can do it if they want. However, if we have a very consistent and
> easy to use subroutines for those weird decompress stuff, it is likely
> that they will use it.
>
>   
>>> As an example, every application do deinterlacing internally or not...
>>> Application developers will probably not use pwlib v4l extensions 
>>> because they will prefer to write adapted codecs for their framework.
>>>       
>
> I think we shouldn't deal with deinterlacing. the API should be as
> simple as possible, focusing on implementing some stuff highly linked
> with the hardware (like specific decompression stuff, proprietary
> colospace conversions, etc).
>   
>>> Much more important for me is to see the actual specification of the 
>>> needed v4l extensions points, with advice/participation of 
>>> application/codec developers.
>>>       
>> As an example, we could empacket frames with a header containing 
>> audio/video format as it is done for MPEG streams.
>> Is it possible without breaking the current ABI?
>>     
>
> Yes, it is possible. In fact, some devices currently work by generating
> a common audio and video stream. The driver may just send the packet
> as-is, leaving to the userspace API the function to de-merge and
> synchronize audio and video.
>   
So we have a userspace lib that will demux/uncompress device driver output.
This lib will know each device driver particularities to know how to 
demux/uncompress in a a/v format that will be understood by the application.
>   
>> Do application developers would cope with that?
>>     
>
> Maybe.
>  
> Cheers,
> Mauro
>
>   
Thanks
Thierry
