Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0CJIF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:05:57 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:51824 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0CJIFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:05:53 -0500
X-Greylist: delayed 8625 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 03:05:53 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uhqD6vyYFd5bGYoXpdMJGUM42nqlnyX+qxC6pS40LOGV+iLmESWLIn2SyNBJFP6G5K
         n6OMDhT1PiknUMsAWpUOkchDhQKROKaIgEnnr1Cgz/aJ3VNH3lA7GhMhGEccikv0WgaO
         /KqcCVcFfSr9g/Am7cP+BqyDxVJVMvrIlbvzk=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>
References: <s5h1vg0qrrr.wl%tiwai@suse.de> <s5htyswpb18.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD557@HKMAIL01.nvidia.com>
	 <s5hvddcnlr6.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com>
	 <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com>
	 <20100308044614.GA29026@localhost>
	 <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
	 <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>
Date: Wed, 10 Mar 2010 00:05:52 -0800
Message-ID: <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
From: VDR User <user.vdr@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 11:58 PM, Jaroslav Kysela <perex@perex.cz> wrote:
> On Tue, 9 Mar 2010, VDR User wrote:
>
>> On Sun, Mar 7, 2010 at 8:46 PM, Wu Fengguang <fengguang.wu@intel.com>
>> wrote:
>>>
>>> CC Jaroslav, maybe he has some idea on
>>>
>>>        pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
>>>
>>> On Mon, Mar 08, 2010 at 12:35:37PM +0800, Wei Ni wrote:
>>>>
>>>> Hi,
>>>> Because I don't have GT220 card on hand, I didn't test it yet.
>>>> So I didn't add this card to the patch file. I think you could add it
>>>> after
>>>> you test it.
>>>>
>>>> About the warning messages, I don't know why.
>>>> May be some others can answer.
>>>>
>>>> Thanks
>>>> Wei.
>>>> nvpublic
>>>>
>>>> -----Original Message-----
>>>> From: VDR User [mailto:user.vdr@gmail.com]
>>>> Sent: Monday, March 08, 2010 3:22 AM
>>>> To: Wei Ni
>>>> Cc: Takashi Iwai; akpm; alsa-devel; Wu Fengguang; linux-kernel; Pavel
>>>> Hofman
>>>> Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
>>>>
>>>> I think this may be relevant to this subject, if not then my apologies.
>>>>
>>>> I've just installed a GT220 card and was able to get audio-over-hdmi
>>>> working by compiling the snapshot drivers from 20100307 which contain
>>>> Wei's new code.  I further had to patch the driver to recognize my
>>>> card with:
>>>>
>>>> --- alsa-driver-orig/alsa-kernel/pci/hda/patch_nvhdmi.c 2010-03-06
>>>> 18:00:12.000000000 -0800
>>>> +++ alsa-driver/alsa-kernel/pci/hda/patch_nvhdmi.c      2010-03-06
>>>> 18:02:00.000000000 -0800
>>>> @@ -1335,6 +1335,8 @@ static struct hda_codec_preset snd_hda_p
>>>>           .patch = patch_nvhdmi_8ch_89 },
>>>>         { .id = 0x10de000b, .name = "GT21x HDMI",
>>>>           .patch = patch_nvhdmi_8ch_89 },
>>>> +       { .id = 0x10de000a, .name = "GT220 HDMI",
>>>> +         .patch = patch_nvhdmi_8ch_89 },
>>>>         { .id = 0x10de000d, .name = "GT240 HDMI",
>>>>           .patch = patch_nvhdmi_8ch_89 },
>>>>         {} /* terminator */
>>>> @@ -1347,6 +1349,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0006"
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de0007");
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de0067");
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de8001");
>>>> +MODULE_ALIAS("snd-hda-codec-id:10de000a");
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de000c");
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de000b");
>>>>  MODULE_ALIAS("snd-hda-codec-id:10de000d");
>>>>
>>>> This seems to work fine when running VDR but if I do anything else
>>>> like upgrade packages, compile something, or maybe create a bz2, then
>>>> I start to see _a lot_ of the following in my xine log:
>>>>
>>>> pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
>>>>
>>>> With the old code this didn't happen.  However, my setup was an 8400gs
>>>> using SPDIF OUT from my mainboard to SPDIF IN on the card.  Then using
>>>> a dvi->hdmi cable into the tv.
>>>>
>>>> Again, I apologize if I'm posting this in the wrong place.
>>>>
>>>> Best regards.
>>
>> So nobody has any ideas at all?  This is turning out to be a big
>> problem and I've discovered it will occur even without anything else
>> happening on the system.  (originally I thought you needed to do some
>> other activity.)  I've checked with some other devs I know and
>> everyone has said the problem is with alsa so it would seem there is a
>> serious bug somewhere since eventually those errors will happen and
>> the audio will start skipping like crazy.
>>
>> Please let me know if there's anything I can do within my ability to help.
>
> Could you do strace for ALSA ioctls? At least having the error code might
> help to identify this issue.

I don't know how but I'm willing to try if you want to tell me how to
do it.  Please keep in mind, I'm just an end-user -- not a developer
or even c coder.  The most I've done is run xine in gdb to help supply
bug info to those devs.
