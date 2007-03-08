Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXCHPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXCHPoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXCHPoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:44:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:32784 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXCHPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ICr2+la6XVU+Pgyt6vNC5WxuBFFEptNko377O/lPVm8EcoeUxFvreLHaxVeTERJzkyBtauy58VajkLUwVnqbCrBiLyx8jpbodUhahVzdCdmOAzlmO4kOmqFkxEDPQE3ZtPzTKuNiTJsidYkDWWISPlHtRCmJ+OGyDnTZl0oNOr0=
Message-ID: <45F02EE2.6040606@googlemail.com>
Date: Thu, 08 Mar 2007 16:42:26 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Cushman <rcushman_linux@earthlink.net>,
       Jaroslav Kysela <perex@suse.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>	<45EC2DEB.1050108@googlemail.com>	<45EEA3C4.7000501@googlemail.com>	<20070307104746.f08a2e84.akpm@linux-foundation.org>	<6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>	<20070307115024.756c848f.akpm@linux-foundation.org>	<s5hvehcrdod.wl%tiwai@suse.de>	<45EF3B2C.9060801@googlemail.com> <s5hfy8gbrmj.wl%tiwai@suse.de>
In-Reply-To: <s5hfy8gbrmj.wl%tiwai@suse.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai napisa³(a):
> At Wed, 07 Mar 2007 23:22:36 +0100,
> Michal Piotrowski wrote:
>> Hi Takashi,
>>
>> Takashi Iwai napisa³(a):
>>> At Wed, 7 Mar 2007 11:50:24 -0800,
>>> Andrew Morton wrote:
>>>> On Wed, 7 Mar 2007 20:41:30 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>>>>
>>>>>>> 831466f4ad2b5fe23dff77edbe6a7c244435e973 is first bad commit
>>>>>>> commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
>>>>>>> Author: Randy Cushman <rcushman_linux@earthlink.net>
>>>>>>> Date:   Tue Dec 19 18:42:16 2006 +0100
>>>>>>>
>>>>>>>     [ALSA] ac97 - fix microphone and line_in selection logic
>>>>>>>
>>>>>>>     This patch fixes the Microphone and LINE_IN select logic for
>>>>>>>     Analog Devices surround codecs with shared jacks.  The existing
>>>>>>>     code can never utilize the shared jacks for Microphone and LINE_IN
>>>>>>>     due to the reversed jack selection logic.  The patched code
>>>>>>>     correctly selects the shared jack for input if the 'Channel Mode'
>>>>>>>     selector does not specify that the jack is to be used for output.
>>>>>>>     Specifically, in '2ch' mode the Center/LFE jack is used for
>>>>>>>     microphone input and the Surround jack is used for LINE_IN,
>>>>>>>     in '4ch' mode the Center/LFE jack is used for microphone input
>>>>>>>     and the Surround jack is used for output, and in '6ch' mode
>>>>>>>     both jacks are used for output.
>>>>>>>
>>>>>>>     Signed-off-by: Randy Cushman <rcushman_linux@earthlink.net>
>>>>>>>     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>>>>>     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
>>>>>>>
>>>>>> Is 2.6.21-rc3 similarly broken?
>>>>> Yes.
>>>>>
>>>> OK.  Can you please confirm that applying the below fixes 2.6.21-rc3?
>>>>
>>>> If so, I'll queue it up for application in a week or two if there is no
>>>> progress on this.
>>> [sorry for the late interrupt - I'm just back from a vacation]
>>>
>>> Could you postpone reverting for a while?
>>> I guess this possible regression is limited only to a certain type of
>>> ac97 codec chip.  The patch applied there was a fix for many codec
>>> chips.
>>>
>>> Which codec chip are you using specifically?  Please check
>>> /proc/asound/card0/codec97#0/* file(s).
>> 0-0/0: Analog Devices AD1985
> 
> OK, that's good to know.
> 
>> 	control.43 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'Spread Front to Surround and Center/LFE'
>> 		value true
>> 	}
> 
> So, you're playing two-channel samples and get no output from surround
> and CLFE?

Yes.

> Or, does it happen if you play a real 5.1 channel file?
> (for example, try speaker-test -c6)

It doesn't work for me on both kernels.

> 
> Also, it'd be helpful if you compare
> /proc/asound/card0/codec97#0/ac97#0-0+regs file before and after the
> patch.  This reveals which register bits differ actually.

a2.txt is form 2.6.21-rc3 witchout 831466f4ad2b5fe23dff77edbe6a7c244435e973

diff -uprN a2.txt /proc/asound/card0/codec97#0/ac97#0-0+regs
--- a2.txt      2007-03-08 16:36:47.000000000 +0100
+++ /proc/asound/card0/codec97#0/ac97#0-0+regs  2007-03-08 16:36:49.447083597 +0100
@@ -56,8 +56,8 @@
 0:6e = 0000
 0:70 = 0000
 0:72 = 0004
-0:74 = 1001
-0:76 = 64a4
+0:74 = 1201
+0:76 = 7ca4
 0:78 = 000c
 0:7a = 0000
 0:7c = 4144


2.6.21-rc3 witchout 831466f4ad2b5fe23dff77edbe6a7c244435e973

speaker-test -c6

speaker-test 1.0.13

Playback device is default
Stream parameters are 48000Hz, S16_LE, 6 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 2048 to 16384
Period size range from 1024 to 1024
Using max buffer size 16384
Periods = 4
was set period_size = 1024
was set buffer_size = 16384
 0 - Front Left
 4 - Center
 1 - Front Right
 3 - Rear Right
 2 - Rear Left
 5 - LFE

0, 1 works
4, 3, 2, 5 doesn't work

/proc/asound/card0/codec97#0/ac97#0-0

0-0/0: Analog Devices AD1985

PCI Subsys Vendor: 0x1043
PCI Subsys Device: 0x80f3

Revision         : 0x03
Compat. Class    : 0x00
Subsys. Vendor ID: 0xffff
Subsys. ID       : 0xffff

Capabilities     : -headphone out-
DAC resolution   : 20-bit
ADC resolution   : 16-bit
3D enhancement   : No 3D Stereo Enhancement

Current setup
Mic gain         : +20dB [+20dB]
POP path         : pre 3D
Sim. stereo      : off
3D enhancement   : off
Loudness         : off
Mono output      : MIX
Mic select       : Mic1
ADC/DAC loopback : off
Double rate slots: 10/11
Extended ID      : codec=0 rev=0 AMAP LDAC SDAC CDAC DSA=0 SPDIF DRA VRA
Extended status  : SPCV LDAC SDAC CDAC SPDIF=10/11 VRA
PCM front DAC    : 48000Hz
PCM Surr DAC     : 48000Hz
PCM LFE DAC      : 48000Hz
PCM ADC          : 48000Hz
SPDIF Control    : Consumer PCM Category=0x2 Generation=1 Rate=48kHz

                    Gain     Inverted  Buffer delay  Location
Master Out       :   0.0 dBV    -      16/fs         Rear I/O Panel
AUX Out          :   0.0 dBV    -      16/fs         Rear I/O Panel
Center/LFE Out   :   0.0 dBV    -      16/fs         Rear I/O Panel
Mic 1            :   0.0 dBV    -      16/fs         Rear I/O Panel
Mic 2            :   0.0 dBV    -      16/fs         Rear I/O Panel
Line In          :   0.0 dBV    -      16/fs         Rear I/O Panel



AD18XX configuration
Unchained        : 0x1000,0x0000,0x0000
Chained          : 0x0000,0x0000,0x0000


/proc/asound/card0/codec97#0/ac97#0-0+regs

0:00 = 0090
0:02 = 0303
0:04 = 0303
0:06 = 0003
0:08 = 0000
0:0a = 801e
0:0c = 0002
0:0e = 0042
0:10 = 9f9f
0:12 = 0303
0:14 = 0000
0:16 = 0101
0:18 = 0303
0:1a = 0101
0:1c = 0000
0:1e = 0000
0:20 = 0000
0:22 = 0000
0:24 = 0000
0:26 = 000f
0:28 = 03c7
0:2a = 05f1
0:2c = bb80
0:2e = bb80
0:30 = bb80
0:32 = bb80
0:34 = 0000
0:36 = 9f03
0:38 = 0303
0:3a = 2824
0:3c = 0000
0:3e = 0000
0:40 = 0000
0:42 = 0000
0:44 = 0000
0:46 = 0000
0:48 = 0000
0:4a = 0000
0:4c = 0000
0:4e = 0000
0:50 = 0000
0:52 = 0000
0:54 = 0000
0:56 = 0000
0:58 = 0000
0:5a = 0000
0:5c = 0000
0:5e = 0000
0:60 = 8080
0:62 = 0000
0:64 = 0000
0:66 = 0000
0:68 = 0000
0:6a = 0000
0:6c = 0000
0:6e = 0000
0:70 = 0000
0:72 = 0004
0:74 = 1001
0:76 = 64a4
0:78 = 000c
0:7a = 0000
0:7c = 4144
0:7e = 5375

2.6.21-rc3

speaker-test -c6

speaker-test 1.0.13

Playback device is default
Stream parameters are 48000Hz, S16_LE, 6 channels
Using 16 octaves of pink noise
Rate set to 48000Hz (requested 48000Hz)
Buffer size range from 2048 to 16384
Period size range from 1024 to 1024
Using max buffer size 16384
Periods = 4
was set period_size = 1024
was set buffer_size = 16384
 0 - Front Left
 4 - Center
 1 - Front Right
 3 - Rear Right
 2 - Rear Left
 5 - LFE

0, 1 works
4, 3, 2, 5 doesn't work

/proc/asound/card0/codec97#0/ac97#0-0

0-0/0: Analog Devices AD1985

PCI Subsys Vendor: 0x1043
PCI Subsys Device: 0x80f3

Revision         : 0x03
Compat. Class    : 0x00
Subsys. Vendor ID: 0xffff
Subsys. ID       : 0xffff

Capabilities     : -headphone out-
DAC resolution   : 20-bit
ADC resolution   : 16-bit
3D enhancement   : No 3D Stereo Enhancement

Current setup
Mic gain         : +20dB [+20dB]
POP path         : pre 3D
Sim. stereo      : off
3D enhancement   : off
Loudness         : off
Mono output      : MIX
Mic select       : Mic1
ADC/DAC loopback : off
Double rate slots: 10/11
Extended ID      : codec=0 rev=0 AMAP LDAC SDAC CDAC DSA=0 SPDIF DRA VRA
Extended status  : SPCV LDAC SDAC CDAC SPDIF=10/11 VRA
PCM front DAC    : 48000Hz
PCM Surr DAC     : 48000Hz
PCM LFE DAC      : 48000Hz
PCM ADC          : 48000Hz
SPDIF Control    : Consumer PCM Category=0x2 Generation=1 Rate=48kHz

                    Gain     Inverted  Buffer delay  Location
Master Out       :   0.0 dBV    -      16/fs         Rear I/O Panel
AUX Out          :   0.0 dBV    -      16/fs         Rear I/O Panel
Center/LFE Out   :   0.0 dBV    -      16/fs         Rear I/O Panel
Mic 1            :   0.0 dBV    -      16/fs         Rear I/O Panel
Mic 2            :   0.0 dBV    -      16/fs         Rear I/O Panel
Line In          :   0.0 dBV    -      16/fs         Rear I/O Panel



AD18XX configuration
Unchained        : 0x1000,0x0000,0x0000
Chained          : 0x0000,0x0000,0x0000


/proc/asound/card0/codec97#0/ac97#0-0+regs

0:00 = 0090
0:02 = 0303
0:04 = 0303
0:06 = 0003
0:08 = 0000
0:0a = 801e
0:0c = 0002
0:0e = 0042
0:10 = 9f9f
0:12 = 0303
0:14 = 0000
0:16 = 0101
0:18 = 0303
0:1a = 0101
0:1c = 0000
0:1e = 0000
0:20 = 0000
0:22 = 0000
0:24 = 0000
0:26 = 000f
0:28 = 03c7
0:2a = 05f1
0:2c = bb80
0:2e = bb80
0:30 = bb80
0:32 = bb80
0:34 = 0000
0:36 = 9f03
0:38 = 0303
0:3a = 2824
0:3c = 0000
0:3e = 0000
0:40 = 0000
0:42 = 0000
0:44 = 0000
0:46 = 0000
0:48 = 0000
0:4a = 0000
0:4c = 0000
0:4e = 0000
0:50 = 0000
0:52 = 0000
0:54 = 0000
0:56 = 0000
0:58 = 0000
0:5a = 0000
0:5c = 0000
0:5e = 0000
0:60 = 8080
0:62 = 0000
0:64 = 0000
0:66 = 0000
0:68 = 0000
0:6a = 0000
0:6c = 0000
0:6e = 0000
0:70 = 0000
0:72 = 0004
0:74 = 1201
0:76 = 7ca4
0:78 = 000c
0:7a = 0000
0:7c = 4144
0:7e = 5375


> 
> 
> thanks,
> 
> Takashi
> 

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
