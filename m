Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZA1JDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZA1JDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZA1JD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:03:27 -0500
Received: from omr3.networksolutionsemail.com ([205.178.146.53]:58947 "EHLO
	omr3.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbZA1JDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:03:25 -0500
Message-ID: <49801F57.3050202@nerdgrounds.com>
Date: Wed, 28 Jan 2009 01:03:19 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Eric Anholt <eric@anholt.net>, Mark Knecht <markknecht@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com>	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>	 <1233031451.4851.31.camel@gaiman>	 <5bdc1c8b0901270937h27c48290p4fb5233f06593e44@mail.gmail.com>	 <1233091414.25539.8.camel@gaiman> <497FFD06.8010001@nerdgrounds.com> <21d7e9970901272305n6ec9506bodaaae29915f7914b@mail.gmail.com>
In-Reply-To: <21d7e9970901272305n6ec9506bodaaae29915f7914b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't think of a nice way to say this, but this idea is crack.

Hey, thanks :)
> I can see one use for vramfs which is to use VRAM as a file backing
> store, we won't mention that VRAM is slow. Some caveats being
> the PCI aperture only exposes 1/2 the VRAM on some cards, there is
> more hidden away where the CPU can't find it.
>  and that some cards have made up VRAM (read IGPs).
>   
I actually have in my possession PCI devices that do just that. The 
second half of VRAM can always be found as the "Display controller", 
function #1, where the main VGA device is function #0. A PCI Radeon card 
I have does that, the Intel graphics chipset in my laptop does that... 
vramfs is able to mount that VRAM and use it just fine.

Use lspci -v and look for your VGA card, then at the "Display 
controller" part (PCI class 0x038000), you'll see where that other half is.

And VRAM isn't always slow. It usually is slower than host memory, yes, 
but not slow enough to be useless.
> It doesn't in any way serve as a basis for talking to the GPU behind
> said VRAM or as a basis for any
> sort of backend to talk to the GPU.
>   
It's not supposed to. By design. Someone else runs the GPU. A root-level 
userspace daemon controlling the MMIO registers directly through 
/dev/mem if you like. This might be useful for the XFree86 or X.org guys 
for example.
> Dave.
>
>   
>> My other concern is that GEM with a filesystem might be the best option for
>> 3D gaming, but that it wouldn't work if the driver doesn't know the card.
>> The DRI drivers, as far as I know, are tied to the GPU and chipset of the
>> device (because they have to manage it, after all!). How exactly would GEM
>> work for cards that it doesn't recognize, like one machine of mine with a
>> weird ATI chipset nobody knows how to talk to? If GEM doesn't recognize it,
>> it won't provide VRAM resources to use it, right?
>>
>> This is where vramfs has it's advantage: it's not the absolute best solution
>> for 3D graphics, but it's simple, it can serve as a starting point for GPU
>> experiments from userspace, or if nothing else allows the use of the onboard
>> video RAM on an otherwise unused and unrecognized video device. It's
>> device-agnostic by design.
>>     
>>> The way you want do that is using OpenGL to put your data in textures
>>> and framebuffer objects, and render them.  With KMS, we'll be able to
>>> support EGL even on the console so you can do the work without having an
>>> X environment set up.
>>>
>>> The problem with vramfs as a basis for GPU offload is that most GPU
>>> tasks end up at some point exceeding the size of available
>>> aperture/VRAM.  So you need code that manages loading buffer objects in
>>> and out on demand, managing the execution pipeline and GPU and CPU
>>> caches as required.  We have that with GEM already.
>>>
>>> Remember, writing data to an aperture isn't the hard part of offloading
>>> to the GPU, programming the GPU is.  That's why you use OpenGL or
>>> another abstraction to do it.
>>>
>>>
>>>       
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

