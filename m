Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929Ab0AZNSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0AZNSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882Ab0AZNSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:18:37 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:50417 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881Ab0AZNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:18:35 -0500
Message-ID: <4B5EEBA6.5000405@blueyonder.co.uk>
Date: Tue, 26 Jan 2010 13:18:30 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <s5hr5pd9wsu.wl%tiwai@suse.de> <4B5ED9E4.60106@blueyonder.co.uk> <201001261351.40292.rjw@sisk.pl>
In-Reply-To: <201001261351.40292.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/10 12:51, Rafael J. Wysocki wrote:
> On Tuesday 26 January 2010, Sid Boyce wrote:
>> On 26/01/10 06:58, Takashi Iwai wrote:
> ...
>>> And... is this report for 2.6.32 or for 2.6.33?
>>> If it's with 2.6.32, enable_msi=1 may help instead.
>>>
>>>
>> The motherboard giving the problem is the Asus M2N32-SLI deluxe.
>> 00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio
>> (rev a2)
>>
>> No such problem with the Asus CROSSHAIR II FORMULA motherboard which
>> also has the
>> 00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S
>> High Definition Audio (rev a1)
>>
>> For any kernel >2.6.32-git1 it hangs, i.e 2.6.32-git2 to 2.6.33-rc5.
>> Disabling the sound chip in the BIOS, they all boot.
>> tindog:/etc/modprobe.d # uname -r
>> 2.6.32-git1-smp
>> tindog:/etc/modprobe.d # l /dev/dsp*
>> crw-rw-rw- 1 root audio 14,  3 Jan 26 11:46 /dev/dsp
>> crw-rw-rw- 1 root audio 14, 35 Jan 26 11:46 /dev/dsp2
> 
> Is your adapter build as a module or is it compiled directly into the kernel?
> 
> Rafael
> 
As a module in 2.6.33-git1 and always for all kernels.
# lsmod|grep snd
snd_pcm_oss            40102  0
snd_mixer_oss          14822  1 snd_pcm_oss
snd_seq                52843  0
snd_hda_codec_analog    73538  1
snd_hda_intel          23660  0
snd_hda_codec          75402  2 snd_hda_codec_analog,snd_hda_intel
snd_usb_audio          85288  0
snd_usb_lib            16705  1 snd_usb_audio
snd_rawmidi            21568  1 snd_usb_lib
snd_pcm                81892  4
snd_pcm_oss,snd_hda_intel,snd_hda_codec,snd_usb_audio
snd_seq_device          6514  2 snd_seq,snd_rawmidi
snd_hwdep               6346  2 snd_hda_codec,snd_usb_audio
snd_timer              20760  2 snd_seq,snd_pcm
snd                    66395  13
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_usb_audio,snd_usb_lib,snd_rawmidi,snd_pcm,snd_seq_device,snd_hwdep,snd_timer
snd_page_alloc          7873  2 snd_hda_intel,snd_pcm
soundcore               7147  1 snd
usbcore               146206  6
rtl8187,snd_usb_audio,snd_usb_lib,usbhid,ohci_hcd,ehci_hcd
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

