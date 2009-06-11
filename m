Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbZFKN1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbZFKN1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZFKN06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:26:58 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:42507 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZFKN04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=UDv2p3LJCoFclsUyuGMWJ7RMjTdVHLaNFRCo0GnVfhk+J8Ss445ej16z5JdEUF6R86
         BONBU5fy9v9RISugnNpFmjhed+V6/xudRHpgHpQzmbo3POSqIOvQJw2P8LDHal6/eCs/
         xJ6vT6VBWxtGcju79VppDV3qOjRaI0BzpfFEw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
Date: Thu, 11 Jun 2009 15:32:33 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090611-07944-gc1b019d-dirty; KDE/4.2.3; i686; ; )
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org
References: <20090610.112804.193703669.davem@davemloft.net> <s5hzlcflw2d.wl%tiwai@suse.de> <20090611.050220.179261434.davem@davemloft.net>
In-Reply-To: <20090611.050220.179261434.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906111532.34169.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009 14:02:20 David Miller wrote:
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 10 Jun 2009 21:37:14 +0200
> 
> > Also, it'd be helpful if you can check whether the problem exists in
> > the current sound git tree (for-linus branch), too.
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
> 
> Same behavior as 2.6.30, but debugging messages are formatted differently
> :-)
> 
> [ 1109.062182] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=73728)
> [ 1125.126123] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=861184)
> [ 1131.398094] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1178624)
> [ 1135.579406] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1395712)
> [ 1145.115367] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=1869824)
> [ 1152.688670] PCM: Lost interrupts? (stream=0, delta=16384, intr_ptr=2249728)

[ Just another data point. ]

I'm experiencing similar problem with the sound in recent -next kernels.

Though the only debug data that I'm getting with xrun_debug == 1 is:

XRUN: pcmC0D0p:0
XRUN: pcmC0D0p:0
XRUN: pcmC0D0p:0
XRUN: pcmC0D0p:0
XRUN: pcmC0D0p:0

with xrun_debug == 3:

XRUN: pcmC0D0p:0
Pid: 4718, comm: audacious Not tainted 2.6.30-next-20090611-07944-gc1b019d-dirty #21
Call Trace:
 [<e1074684>] xrun+0x8b/0x92 [snd_pcm]
 [<e10746fd>] snd_pcm_update_hw_ptr_post+0x72/0xa9 [snd_pcm]
 [<e1074c2d>] snd_pcm_update_hw_ptr+0x18f/0x19b [snd_pcm]
 [<e1071b9e>] snd_pcm_common_ioctl1+0xa56/0x14e4 [snd_pcm]
 [<c0141628>] ? getnstimeofday+0x52/0xda
 [<c016ce03>] ? might_fault+0x4b/0x88
 [<c016ce03>] ? might_fault+0x4b/0x88
 [<c016ce03>] ? might_fault+0x4b/0x88
 [<c018ecd3>] ? core_sys_select+0x27e/0x2c9
 [<e1072d51>] snd_pcm_playback_ioctl1+0x37a/0x3d2 [snd_pcm]
 [<e1072e17>] snd_pcm_kernel_ioctl+0x38/0x5d [snd_pcm]
 [<e1297443>] snd_pcm_oss_ioctl+0x7b1/0xc08 [snd_pcm_oss]
 [<c016ce03>] ? might_fault+0x4b/0x88
 [<e1296c92>] ? snd_pcm_oss_ioctl+0x0/0xc08 [snd_pcm_oss]
 [<c018cfab>] vfs_ioctl+0x22/0x69
 [<c018d475>] do_vfs_ioctl+0x483/0x4bd
 [<c01833c3>] ? fget_light+0x43/0xe1
 [<c0183437>] ? fget_light+0xb7/0xe1
 [<c018d4db>] sys_ioctl+0x2c/0x45
 [<c0102988>] sysenter_do_call+0x12/0x36
