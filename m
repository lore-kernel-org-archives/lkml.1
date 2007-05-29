Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXE2F3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXE2F3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXE2F3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:29:30 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:33952 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXE2F33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:29:29 -0400
X-Greylist: delayed 28766 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 01:29:29 EDT
Message-ID: <465BBAFB.30906@free.fr>
Date: Tue, 29 May 2007 07:32:43 +0200
From: Thierry Merle <thierry.merle@free.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
References: <2172422218943432279@wsc.cz>	<1180364420.21547.160.camel@localhost>	<d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>	<1180378677.21547.189.camel@localhost>	<d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>	<1180383071.21547.230.camel@localhost> <465B49EB.4080204@free.fr>
In-Reply-To: <465B49EB.4080204@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Thierry Merle a écrit :
> Mauro Carvalho Chehab a écrit :
>>>> As Luca pointed, if we add conversion for one driver, we should add 
>>>> for
>>>> the rest.
>>>>
>>>> Instead, it would be better if Jiri sends the decoding and the 
>>>> rescaling
>>>> stuff as a patch to v4l2-apps/lib, starting the API decoding library.
>>>> Once we have a library, we can ask the userspace developers to use it
>>>> for the formats not recognized by their userspace apps.
>>>>
>>>>       
>>> I think it would be better to evaluate existing solutions (eg. libpw).
>>>     
>>
>> Agreed. Volunteers?
>>
>>   
> Hi Mauro and Markus,
> Just to summ up what I understood we need:
>
> What do we need in userspace, only for v4l (dvb is not concerned):
> - colorspace translations
> - filters that be done in hardware if the selected hardware can, 
> otherwise software plugin
> - decompression algorithm like stk11xx or usbvision (the decompression 
> algorithm is in kernelspace since it is of linear complexity but shall 
> be moved to userspace)
>
> Using pwlib will not mean that application developers will use pwlib 
> to decode v4l driver outputs.
> C bindings are much more popular than C++ bindings and do not prevent 
> object oriented design.
> Application developers implement their own codecs.
> As an example, every application do deinterlacing internally or not...
> Application developers will probably not use pwlib v4l extensions 
> because they will prefer to write adapted codecs for their framework.
>
> Much more important for me is to see the actual specification of the 
> needed v4l extensions points, with advice/participation of 
> application/codec developers.
As an example, we could empacket frames with a header containing 
audio/video format as it is done for MPEG streams.
Is it possible without breaking the current ABI?
Do application developers would cope with that?
>
> Thierry
>

