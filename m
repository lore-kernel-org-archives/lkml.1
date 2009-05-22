Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZEVSTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZEVSTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZEVSTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:19:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59448 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZEVSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=GEkHZhJdb45WmHdkwPzABGQs9mTVPWBbMA7x9g4TkhCPMZJNrA4Bu3Hrj9dXc1tAGi
         enVSk6NE2l0HU39Hs5By4d77WEf32+uom7jLLF347jzgOwGQ27FZzxI77aEU2SaB04Nx
         4ZT2nRD8FNQ3JGTKBlzC1ANZxrV0pcc+5bQh8=
Message-ID: <4A16EC72.1000802@gmail.com>
Date: Fri, 22 May 2009 20:18:26 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: blank screen - unless keyboard/synaptic combo
References: <4A12FCB2.6090409@gmail.com>  <4A15DC88.5070005@gmail.com> <1242963556.32574.59.camel@rzhang-dt>
In-Reply-To: <1242963556.32574.59.camel@rzhang-dt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fixed top posting)

On 05/22/2009 05:39 AM, Zhang Rui wrote:
> On Fri, 2009-05-22 at 06:58 +0800, Niel Lambrechts wrote:
>
>> Cc's added, attached lspci output.
>>
>> On 05/19/2009 08:38 PM, Niel Lambrechts wrote:
>>
>>> I have a strange problem in that during a resume from hibernate my
>>> text console (or X) remains blank - that is, until I simultaneously
>>> press a keyboard key and touch the synaptic pad. It is not sufficient
>>> to press just one or the other, it needs to be done simultaneously and
>>> it resumes fine after doing this.
>>>
> is this a regression or it exists on all the kernel you've tried?
>
Hi Zhang,

It is not a recent regression, all of the kernels I tried back to 2.6.28 shows 
the same problem. The test results I posted last night was with 2.6.30-rc6. I 
suspect it did not happen in 2.6.27, but I might be wrong since I could not 
bisect that far back (I am using EXT4 and have too many issues to bisect that 
far back).

> please remote login the box after resume, and get the output of
> "xrandr --verbose".
>

When I resume from suspend to RAM there is no problem.

When I resume from hibernate, my laptop actually remains unusable until I do the 
combination of things I mentioned. I cannot log in from remote or even ping the 
laptop, except if I first press the mentioned key combo. Before this, the 
display is either entirely blank or sometimes there is a white cursor in the top 
left corner.

The blank screen happens in runlevel 3 without X or "i915" loaded - I'm not sure 
but I suppose you want the "xrandr" output for another reason. It is interesting 
that it happens regardless of whether I am using Intel integrated graphics or 
Mobility Radeon HD 3650 (my laptop has both and I can enable one at a time). I 
boot the system with vga=791 and it is using vesafb for console.

I attached the output you asked for below after hibernating an Xorg session, but 
this is from just after pressing the combo as I could not log in over the 
network with the laptop in the blank state.

Thanks,
Niel


niella@linux-7vph:> xrandr --verbose
Screen 0: minimum 320 x 200, current 1600 x 1024, maximum 3840 x 1200
VGA disconnected 1600x1024+0+0 (0x3d) normal (normal left inverted right x axis 
y axis) 0mm x 0mm
         Identifier: 0x3b
         Timestamp:  184631
         Subpixel:   unknown
         Clones:
         CRTC:       0
         CRTCs:      0 1
         Transform:  1.000000 0.000000 0.000000
                     0.000000 1.000000 0.000000
                     0.000000 0.000000 1.000000
                    filter:
   1600x1024 (0x3d)  136.4MHz *current
         h: width  1600 start 1704 end 1872 total 2144 skew    0 clock   63.6KHz
         v: height 1024 start 1025 end 1028 total 1060           clock   60.0Hz
LVDS connected 1600x1024+0+0 (0x3d) normal (normal left inverted right x axis y 
axis) 331mm x 207mm
         Identifier: 0x3c
         Timestamp:  184631
         Subpixel:   horizontal rgb
         Clones:
         CRTC:       1
         CRTCs:      1
         Transform:  1.000000 0.000000 0.000000
                     0.000000 1.000000 0.000000
                     0.000000 0.000000 1.000000
                    filter:
         EDID_DATA:
                 00ffffffffffff0030ae554000000000
                 0011010380211578ea87f594574f8c27
                 27505400000001010101010101010101
                 0101010101018c41807a71b011403020
                 33004bcf100000197434802071b01440
                 302026004bcf100000190000000f00d1
                 0a32d10a281101004ca35532000000fe
                 004c544e31353455322d4c30350a0011
         PANEL_FITTING:  full_aspect
                 supported: center       full_aspect  full
         BACKLIGHT_CONTROL:      combination
                 supported: native       legacy       combination  kernel
         BACKLIGHT: 4722 (0x00001272)    range:  (0,4722)
   1600x1024 (0x3d)  136.4MHz *current +preferred
         h: width  1600 start 1704 end 1872 total 2144 skew    0 clock   63.6KHz
         v: height 1024 start 1025 end 1028 total 1060           clock   60.0Hz
   1920x1200 (0x3e)  167.8MHz -HSync -VSync +preferred
         h: width  1920 start 1968 end 2000 total 2298 skew    0 clock   73.0KHz
         v: height 1200 start 1203 end 1206 total 1217           clock   60.0Hz
   1920x1200 (0x3f)  134.3MHz -HSync -VSync
         h: width  1920 start 1968 end 2000 total 2208 skew    0 clock   60.8KHz
         v: height 1200 start 1202 end 1208 total 1220           clock   49.8Hz
   1600x1200 (0x40)  162.0MHz +HSync +VSync
         h: width  1600 start 1664 end 1856 total 2160 skew    0 clock   75.0KHz
         v: height 1200 start 1201 end 1204 total 1250           clock   60.0Hz
   1400x1050 (0x41)  122.0MHz +HSync +VSync
         h: width  1400 start 1488 end 1640 total 1880 skew    0 clock   64.9KHz
         v: height 1050 start 1052 end 1064 total 1082           clock   60.0Hz
   1280x1024 (0x42)  108.0MHz +HSync +VSync
         h: width  1280 start 1328 end 1440 total 1688 skew    0 clock   64.0KHz
         v: height 1024 start 1025 end 1028 total 1066           clock   60.0Hz
   1280x960 (0x43)  108.0MHz +HSync +VSync
         h: width  1280 start 1376 end 1488 total 1800 skew    0 clock   60.0KHz
         v: height  960 start  961 end  964 total 1000           clock   60.0Hz
   1024x768 (0x44)   65.0MHz -HSync -VSync
         h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz
         v: height  768 start  771 end  777 total  806           clock   60.0Hz
   800x600 (0x45)   40.0MHz +HSync +VSync
         h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9KHz
         v: height  600 start  601 end  605 total  628           clock   60.3Hz
   800x600 (0x46)   36.0MHz +HSync +VSync
         h: width   800 start  824 end  896 total 1024 skew    0 clock   35.2KHz
         v: height  600 start  601 end  603 total  625           clock   56.2Hz
   640x480 (0x47)   25.2MHz -HSync -VSync
         h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KHz
         v: height  480 start  490 end  492 total  525           clock   59.9Hz

