Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYKLRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYKLRU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYKLRUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:20:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:6788 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYKLRUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=s8WuquXSO8AN+JkV59D8KR7kOapW+56zjkTUMToEakRS0PvQIvf+iAuxSZVsm10gxJ
         3uHRKEHKuZoJj8g7jw6Eor9TNqR2LKUEY4YpVA4XcoUoaiZIOH+HM2hhvv/ETLmWX8rf
         ycTcTH/pSjObWoZuWFg9tb1WvoGznafrCP338=
Message-ID: <491B1048.5020107@gmail.com>
Date: Wed, 12 Nov 2008 19:20:08 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
References: <s5h3ai11dpt.wl%tiwai@suse.de>	<20081109151323.GA18705@rhlx01.hs-esslingen.de>	<s5h7i7c916e.wl%tiwai@suse.de>	<20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de>
In-Reply-To: <s5hiqqtkxqr.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------040607010408050702060000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040607010408050702060000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Takashi Iwai wrote:
> At Sun, 9 Nov 2008 21:09:29 +0100,
> Andreas Mohr wrote:
>> On Sun, Nov 09, 2008 at 07:58:17PM +0100, Takashi Iwai wrote:
>>> At Sun, 9 Nov 2008 16:13:23 +0100,
>>> Andreas Mohr wrote:
>>>> OK, _THIS_ time I actually did get the correct model (last time I tried
>>>> modprobe with model=acer-aspire, but apparently it then used the
>>>> /etc/modprobe.d/ model=toshiba setting, since this time gamix showed
>>>> entirely different controls with i-Mic etc.) - all the more reason to
>>>> log the model name chosen/selected by the driver!!
>>> Build with the debug option (why turned off even if you *are*
>>> debugging?).  Then the driver will show you details.
>> Hmm, right, that would have been an (very useful) option, but not for the
>> majority of users OTOH.
> 
> I thought many ditros set this option...
> 
>> Especially since this is a user-visible module parameter which should thus
>> be confirmed in mainstream user code, via logging.
> 
> You can check via /sys/modules/snd_hda_intel/parameters/model whether
> you passed correctly or not, at least :)
> 
>> Admittedly not many modules log their settings during startup,
>> but for snd_hda_intel with its two myriads of codec/machine variants
>> and a resulting quarter myriad of issues that would be very useful.
> 
> Passing the model option is already a kind of debugging work, IMO.
> You shouldn't do it unless you need it, indeed.
> 
>>>> --> I have to admit that usability sucks^Hcould be a lot better.
>>> One would call it rather debuggability than usability.
>>> These are completely different things.
>> See above ;)
>>
>>>> i-Mic on Ekiga with lotsa mixer fiddling didn't work either this time.
>>> OK, then something is missing.  But you should test by arecord first
>>> than any complicated applications as a primary test.
>> Good point, will do.
>>
>> Oh, and is there a way to manually alter codec registers?
> 
> Try hda-verb program.  Build your kernel with CONFIG_SND_HDA_HWDEP=y
> and access via the hwdep device.
> 	ftp://ftp.suse.com/pub/people/tiwai/misc/hda-verb-0.2.tar.bz2
> 
> 
> Takashi


For the reference this this list of nodes on ALC268 (main mobo):

0x01 - params


output streams:
0x02 - DAC1 + volume
0x03 - DAC2 + volume (only headphones)
0x06 - s/pdif-out
0x1D - BEEP


input streams:
0x07 - ADC1
0x23 - ADC1 multiplexer + volume
0x08 - ADC2
0x24 - ADC2 multiplexer + volume


output pins(*):		(***)

0x14 - LINE-OUT		headphones	<- 0x0f - line-out (mixer) <- DAC1 + beep
0x15 - HP-OUT		speakers	<- 0x10 - hp-out  (mixer) <- DAC1 + DAC2 + beep
0x16 - MONO-OUT		N/A		<- 0x0e - mono out (mixer) <- DAC1
0x1E - spdif		


input pins(**):
0x12 - DMIC1/2		N/A
0x13 - DMIC3/4		N/A
0x18 - MIC1		external mic + boost
0x19 - MIC2		internal mic + boost
0x1A - LINE-IN		line-in + boost
0x1C - CD-IN		N/A		


*  Most output pins may be used as input pins
** LINE-IN, MIC1 might be output of DAC1
*** those are pins that are connected on my main mobo.


/proc/asound/card0/codec#0  is attached (also for main computer, I will 
test the 'one' tomorrow 


Best regards,
	Maxim Levitsky

--------------040607010408050702060000
Content-Type: text/plain;
 name="codec.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="codec.txt"

Codec: Realtek ALC268
Address: 0
Vendor Id: 0x10ec0268
Subsystem Id: 0x1025011e
Revision Id: 0x100003
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0
Node 0x02 [Audio Output] wcaps 0x1d: Stereo Amp-Out
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x32 0x32]
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x1d: Stereo Amp-Out
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x32 0x32]
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x5e0]: 44100 48000 88200 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x100111: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x100111: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0b [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0c [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0d [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0e [Audio Mixer] wcaps 0x20010a: Mono Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00]
  Connection: 1
     0x02
Node 0x0f [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80]
  Connection: 2
     0x02 0x1d
Node 0x10 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80]
  Connection: 3
     0x03 0x1d 0x02
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x0820: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x13 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x0820: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x081003c: IN OUT HP EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x0221101f: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=04, enabled=1
  Connection: 1
     0x0f
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x081003c: IN OUT HP EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x99130110: [Fixed] Speaker at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x10
Node 0x16 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80]
  Pincap 0x0810: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x083734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02a19840: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x19 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x083724: IN Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x99a30941: [Fixed] Mic at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0x4, Sequence = 0x1
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x083734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x0281304e: [Jack] Line In at Ext Front
    Conn = 1/8, Color = Blue
    DefAssociation = 0x4, Sequence = 0xe
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x02
Node 0x1b [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x0820: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x0820: IN
  Pin Default 0x4017952d: [N/A] Speaker at Ext N/A
    Conn = Analog, Color = Pink
    DefAssociation = 0x2, Sequence = 0xd
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400380: Mono Digital
  Pincap 0x0810: OUT
  Pin Default 0x02451130: [Jack] SPDIF Out at Ext Front
    Conn = Optical, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=10
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x23 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x0b, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x0b 0x0b]
  Connection: 7
     0x18* 0x19 0x1a 0x1c 0x14 0x15 0x12
Node 0x24 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x0b, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00 0x00]
  Connection: 7
     0x18* 0x19 0x1a 0x1c 0x14 0x15 0x13

--------------040607010408050702060000--
