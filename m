Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbYHNTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbYHNTKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYHNTKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:10:06 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:46140 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYHNTKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=feNEK3nxn7WmUm54XDQx6aZA8AL4KS7Jd8t5oyLdXXwC+MiIPkQjun+bKayCdJ+Lc2
         uN3V5dOEmsSSRUvET9YsIpaNrH7sf+M67fuZKKPDuEUSfFc/NtCu62+As1TRVbc4Q6ct
         GyaUVYVR0fkKB47PqpeBU6s+ttdyD3BPcFvrg=
Message-ID: <6278d2220808141210p3c612feen6fe779bc84a4ae78@mail.gmail.com>
Date: Thu, 14 Aug 2008 20:10:03 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

I am still finding this recording +ve saturation on my ALC883 Intel
HDA sound device with 2.6.27-rc3 (ie ALSA 1.0.17 drivers) and ALSA
1.0.16-1 libraries on Ubuntu Intrepid.

The previous workaround still 'gets us out of jail':

# ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7180
nid = 0x23, verb = 0x300, param = 0x7180
value = 0x0

Note, we see this message "hda_codec: Unknown model for ALC883, trying
auto-probe from BIOS..." as before on this Asus P5E-VM HDMI
motherboard with current BIOS.

How can we improve the situation, as out the box, the front/rear mic
inputs are (still) useless?

Many thanks,
  Daniel

On Sat, Jun 28, 2008 at 11:29 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Sat, Jun 28, 2008 at 11:11 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Sat, Jun 28, 2008 at 2:05 AM, Daniel J Blueman
>> <daniel.blueman@gmail.com> wrote:
>>> As the mic is working fine, but with this variable DC offset, it felt
>>> like something needed tweaking in the mixer (summation) node. I
>>> understand more about the node connectivity now, and found muting the
>>> front mic mixer input and setting LR gain to 0 at mixer node 23h
>>> addresses the issue:
>>>
>>> (from page 42 at ftp://66.104.77.130/pc/audio/ALC883_DataSheet_1.3.pdf)
>>>
>>> # ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7180
>>>
>>
>> Are you saying that this fixes the problem completely for you?
>
> Yes, this addresses the problem squarely. The front mix mixer input is
> adding this offset, looks like they have a capacitor between a
> reference voltage and the pin or something, so it floats up.
>
>>> Vegard - your HD bus enumeration looks similar and I'd bet the vendor
>>> followed the same Realtek application note, so can you give this a
>>> shot too? If not, try mixer node 20h.
>>>
>>
>> I agree. Thanks for the link, I found ALC268 now as well, and I am
>> experimenting...
>>
>> I think 23h is [in]correct -- this is the one with caps f00040h for me too.
>>
>> But neither of them had any effect at all.
>
> OK, I'll take another look at the debug output you posted; I forgot
> you aren't using the ALC883.
-- 
Daniel J Blueman
