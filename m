Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbXBCXUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbXBCXUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXBCXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:20:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:58845 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbXBCXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G7w9gcsQWxNphU2swqkrw+sxoUCMvdV5hXSclQzFlMfuPK1sKz5ykXKJVyA7FOyj0C3ZCtcrI+Yurt56g17kcXQoMtOh8uKtOroOkOwlw9JSn0Rtzqeri4It4OWv8Gwd00Ti4TbWXoBzZ9bQ0Vw0TGYHJAwWLJPhnowfbZ1VMk0=
Message-ID: <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com>
Date: Sun, 4 Feb 2007 10:20:29 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: ebuddington@wesleyan.edu
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
Cc: "Lee Revell" <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org,
       "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
	 <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com>
	 <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
> agpgart: Device is in legacy mode, falling back to 2.x
> agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
> agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pde = 48057067
> Oops: 0000 [#1]
> last sysfs file: /devices/pci0000:00/0000:00:00.0/class
> Modules linked in: ppp_synctty ppp_async crc_ccitt ppp_generic slhc r128 drm softdog keyspan_pda usbserial sch_tbf raw1394 dv1394 ohci1394 ieee1394 snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_cs8427 snd_i2c snd_mpu401_uart snd_rawmidi usbnet snd_intel8x0 snd_ac97_codec ac97_bus ipt_tos ipt_owner iptable_nat nf_conntrack_ipv4 ipt_MASQUERADE nf_nat nf_conntrack nfnetlink ipt_TOS iptable_filter iptable_mangle ip_tables x_tables 8139too sis900 sis5595 hwmon i2c_isa i2c_core sis_agp agpgart ide_scsi
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00013246   (2.6.20-rc6-mm3 #1)
> EIP is at 0x0
> eax: f5e6f2e0   ebx: 00000000   ecx: f928eda0   edx: 00000000
> esi: f5e6f2e0   edi: f3604be0   ebp: 00004000   esp: f2c2feb0
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process X (pid: 3465, ti=f2c2e000 task=f2c10ab0 task.ti=f2c2e000)
> Stack: f9299ccc 00003292 f2401f10 00000010 c164f880 00000000 00000000 00000163
>        f928eda0 f3604be0 00000000 f3bfb000 f929928c f5e6f2e0 00000000 f37113e0
>        00000000 f3604160 f93e77bf f93f1800 c029926f 00000000 f93f1810 f3bfb000
> Call Trace:
>  [<f9299ccc>] agp_generic_insert_memory+0x5f/0x147 [agpgart]
>  [<f929928c>] agp_bind_memory+0x53/0x64 [agpgart]
>  [<f93e77bf>] drm_agp_bind+0x49/0x9f [drm]
>  [<c029926f>] copy_to_user+0x2d/0x42
>  [<f93e7845>] drm_agp_bind_ioctl+0x30/0x39 [drm]
>  [<f93e7815>] drm_agp_bind_ioctl+0x0/0x39 [drm]
>  [<f93e3f10>] drm_ioctl+0x14b/0x193 [drm]
>  [<f93e3dc5>] drm_ioctl+0x0/0x193 [drm]
>  [<c015b94a>] do_ioctl+0x3e/0x4d
>  [<c015bb60>] vfs_ioctl+0x207/0x21e
>  [<c015bbaa>] sys_ioctl+0x33/0x4d
>  [<c0104b30>] sysenter_past_esp+0x5d/0x81
>  =======================
> Code:  Bad EIP value.
> EIP: [<00000000>] 0x0 SS:ESP 0068:f2c2feb0
> [drm:drm_release] *ERROR* Device busy: 1 0

What AGP chipset do you have? it looks like it might be caused by the
AGP changes for TTM..

Dave.
