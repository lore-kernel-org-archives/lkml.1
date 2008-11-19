Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYKSPnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYKSPnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYKSPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:42:51 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:36722 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYKSPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KZvIvyYEztETWONDl0ZODZgMNRiu5cf2HJ5qT1Bniyqe7JRo/iDTnWaRrgt8vdDHzc
         A+TC0d/uGsNRCy9/HApYSJwY3rn1Sgwn1DuwRP+YJrwqUXNQeVDb9jhVTTuu56eXg3Gc
         Cm0g3SA5uamypoUJJU/ODVYYbS5JMHCG7ilTM=
Message-ID: <386072610811190742ycab0dbasc585376dc6ac47db@mail.gmail.com>
Date: Wed, 19 Nov 2008 23:42:48 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Question] Can I open a substream in kernel space without attach to a file pointer?
Cc: "ALSA devel" <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h63mjddvj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610811190200l576d7735rb0188ab53f5185fa@mail.gmail.com>
	 <s5h63mjddvj.wl%tiwai@suse.de>
X-Google-Sender-Auth: aee329e9f82951f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 9:49 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 19 Nov 2008 18:00:36 +0800,
> Bryan Wu wrote:
>>
>> Hi Takashi,
>>
>> I am developing a USB gadget driver compliant to USB Audio Class Spec 2.0.
>> So I want to open a PCM substream and do some playback of capture,
>> then close them?
>>
>> I found snd_pcm_open_substream() is for opening a substream and attach
>> it to a file.
>> But in my application, there is no need to open a file before opening
>> a substream.
>>
>> - Is there any interface for me to open a substream in kernel space
>> without attach to a file?
>> - How to playback and capture in kernel space, use snd_pcm_lib_write
>> and snd_pcm_lib_read?
>> - How to get the snd_pcm_hardware struct from low level driver,
>> because I have to get the hardware configuration of the snd pcm
>> device?
>>
>> And I am reading the code of OSS emulator in ALSA. It provides some
>> info about the kernel space sound card programming.
>
> Yes, OSS emulation code handles the PCM in the kernel.
> But, basically I don't recommend you to do this -- it's not the job of
> the sound card driver.  The whole PCM stuff is handled by the PCM
> middle layer, not the driver itself.

No, my plan is not a sound card driver. It is an USB gadget audio driver.
When an embedded system for example Blackfin board connects to a USB host (PC),
PC will recognize this USB device as a USB Audio Class device.

Generally, there should be a sound card on the embedded system. Our
Blackfin board
has an AD1980 ALSA sound card. The USB gadget audio driver will open this sound
card and export this device to USB host PC by some USB audio class specific
descriptors. Then the PC can playback some audio stream by USB cable, USB gadget
audio driver will receive this stream and playback the data by AD1980
ALSA playback
substream. Capture is the similar.

> Any reason why you handle the PCM stuff completely in your driver
> code?
>

There is USB gadget MIDI driver in kernel. But it asked the user to
use aconnect tool to
connect the virtual MIDI card to a real one. I don't want travel to
user space and it should
be more efficient in kernel space to handle all things including PCM
open/release/read/write
and Mixer control.

Any hints about this? I really need some help from ALSA guru, cause
I'm not familiar the internal
things here.

Thanks a lot
-Bryan
