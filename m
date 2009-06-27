Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZF0NjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZF0NjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZF0NjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 09:39:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50746 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZF0NjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 09:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xpXPlVtIUE89THksSBcEt1BJSBdXY1xNY+/mELgk1DSg9X6SRgH9O8hKuMpwHk2wkZ
         h6vj/nMcfwNYY6f1KhECOiCc3tysCGV86JMRNwiPDsDzzrdeY+7UOQPRnFSmQYBllczh
         scS6hvGUAVRPTv8L1rubEeFufszfdMgZezpRU=
Message-ID: <4A4620FC.5030708@googlemail.com>
Date: Sat, 27 Jun 2009 15:39:08 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090610)
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [git pull] drm fixes + intel display port
References: <alpine.DEB.2.00.0906240723420.18292@skynet.skynet.ie>	 <1820d69d0906240715v6c3591c4x30ee87e9ec8774f7@mail.gmail.com>	 <4A4238D2.2060501@googlemail.com> <21d7e9970906251631h272607d6scee36997a0c574ab@mail.gmail.com> <8FED46E8A9CA574792FC7AACAC38FE7701E6AAB162@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7701E6AAB162@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ma, Ling wrote:

>> -----Original Message-----
>> From: Dave Airlie [mailto:airlied@gmail.com]
>> Sent: 2009年6月26日 7:32
>> To: Gabriel C
>> Cc: Dave Airlie; Ma, Ling; LKML; Keith Packard; Eric Anholt
>> Subject: Re: [git pull] drm fixes + intel display port
>>
>> On Thu, Jun 25, 2009 at 12:31 AM, Gabriel C<nix.or.die@googlemail.com> wrote:
>>> [ forgot to CC LKML , sorry ]
>>>
>>> Gabriel C wrote:
>>>
>>>> 2009/6/24 Dave Airlie <airlied@linux.ie>:
>>>>> Hi Linus,
>>>>>
>>>>> Please pull the 'drm-fixes' branch from
>>>>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
>> drm-fixes
>>>> Hi Dave ,
>>>>
>>>> I own an DQ45CB Intel motherboard. When enabling KMS with kernels from
>>>> 2.6.29* to current git / linux-next on that board
>>>> I don't get any console. My Monitor is saying 'No signal' , however
>>>> once X starts up I can login in KDE/gnome etc.
>>>>
>>>> The monitor is connected with an DVI-I -> VGA connector.
>>>>
>>>> I found on the gfx mailing list the following patch from Ma Ling :
>>>>
>>>> http://lists.freedesktop.org/archives/intel-gfx/2009-May/002504.html
>>>>
>>>> which seems to fix my problem. With that patch applied I get a console
>>>> and everything works fine.
>>>>
>>>> However I still have such :
>>>>
>>>> [   21.205449] i2c-adapter i2c-1: unable to read EDID block.
>>>> [   21.205452] i915 0000:00:02.0: VGA-1: no EDID data
>>>>
>>>>
>>>> messages in my dmesg but it works.
>>>>
>>>>
>>>> Is there any reason why this patch never got merged ?
>> I don't think that patch is totally correct, it looks more like a lets
>> try everything approach, I'll cc more Intel folks and see what they can do.
>>
>> Dave.
>>
> Yes, I have refined the patch [Resend][PATCH 1/4] drm/i915: crt fetch EDID by DVI-I converter on G4x platform, and  re-sent to mailing list. In that version we specified G4x platform which used GPIOD as port, which is wired to I2C bus of VGA or HDMI. Any comments from Eric?

You mean http://lists.freedesktop.org/archives/intel-gfx/2009-June/002955.html ? If is so I can confirm this patch is working on my
motherboard too.

However on current git ( 2.6.31-rc1-00114-g4075ea8-dirty ) Have some new drm errors/warnings I never got before:

...

[    6.215535] [drm] Initialized drm 1.1.0 20060810
[    6.354943] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.354946] i915 0000:00:02.0: setting latency timer to 64
[    6.367517]   alloc irq_desc for 34 on node -1
[    6.367520]   alloc kstat_irqs on node -1
[    6.367530] i915 0000:00:02.0: irq 34 for MSI/MSI-X
[    6.372899] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-B
[    6.375957] dp_aux_ch timeout status 0x514500c8
[    6.375997] aux_ch failed -110
[    6.378944] dp_aux_ch timeout status 0x514500c8
[    6.378984] aux_ch failed -110
[    6.384150] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-C
[    6.387204] dp_aux_ch timeout status 0x514500c8
[    6.387244] aux_ch failed -110
[    6.390189] dp_aux_ch timeout status 0x514500c8
[    6.390229] aux_ch failed -110
[    6.417734] i2c-adapter i2c-1: unable to read EDID block.
[    6.417736] i915 0000:00:02.0: VGA-1: no EDID data
[    6.624401] dp_aux_ch timeout status 0x514500c8
[    6.628947] allocated 1280x1024 fb: 0x02020000, bo ffff88007a136480
[    6.630266] Console: switching to colour frame buffer device 160x64
[    6.690944] [drm] DAC-6: set mode 1280x1024 20
[    6.714585] fb0: inteldrmfb frame buffer device
[    6.714587] registered panic notifier

....
[  329.114444] i2c-adapter i2c-1: unable to read EDID block.
[  329.114448] i915 0000:00:02.0: VGA-1: no EDID data
[  329.421751] dp_aux_ch timeout status 0x514500c8
[  329.424764] dp_aux_ch timeout status 0x514500c8
[  329.462443] i2c-adapter i2c-1: unable to read EDID block.
[  329.462446] i915 0000:00:02.0: VGA-1: no EDID data
[  329.800624] dp_aux_ch timeout status 0x514500c8
[  329.803636] dp_aux_ch timeout status 0x514500c8
[  352.215440] i2c-adapter i2c-1: unable to read EDID block.
[  352.215444] i915 0000:00:02.0: VGA-1: no EDID data
[  352.523889] dp_aux_ch timeout status 0x514500c8
[  352.526902] dp_aux_ch timeout status 0x514500c8
[  358.049548] i2c-adapter i2c-1: unable to read EDID block.
[  358.049552] i915 0000:00:02.0: VGA-1: no EDID data
[  358.358469] dp_aux_ch timeout status 0x514500c8
[  358.361488] dp_aux_ch timeout status 0x514500c8
[  358.412680] i2c-adapter i2c-1: unable to read EDID block.
[  358.412684] i915 0000:00:02.0: VGA-1: no EDID data
[  358.721347] dp_aux_ch timeout status 0x514500c8
[  358.724361] dp_aux_ch timeout status 0x514500c8
....



Gabriel


