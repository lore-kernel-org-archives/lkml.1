Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZGBThj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZGBThj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZGBTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:37:30 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:44561 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZGBTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MGkizpTyeUkd9Q6tPdTgOGSV6ezsWV4qMKCUlJQcTvO51oXDhNgtuN8eCyJbR5Lb/4
         hzpSkTk5zaoWF5NkUn3ESkGfHBOnIRqR4Vqgckbf56NitAdG8QYBr8pyZ57fngCLXJQZ
         Kja9cjHfgzS7PqBaJlnwE34Hb8IL582uIPwEw=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Thu, 2 Jul 2009 21:37:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907020818.58541.info@gnebu.es> <20090702093547.7ca95116@jbarnes-g45>
In-Reply-To: <20090702093547.7ca95116@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907022137.27847.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009 18:35:47 Jesse Barnes wrote:
> On Thu, 2 Jul 2009 08:18:58 +0200
>
> Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > Thanks, the patch applied to 2.6.30 and when the problem stars I get
> > these two lines repeated all the time in dmesg:
> >
> > [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat
> > 0x10200300 [drm:i915_driver_irq_handler] *ERROR* hotplug event
> > received, stat 0x18200300
> >
> > Is this enough or should I provide something else?
>
> Interesting.  That hotplug status shouldn't end up generating any
> uevents.  Can you try this patch to see what's going on?

This is what I get with the patch applied (repeated again and again):

------------[ cut here ]------------
WARNING: at drivers/gpu/drm/drm_sysfs.c:452 drm_sysfs_hotplug_event+0x3e/0x90 
[drm]()
Hardware name: Studio 540
hotplug uevent
Modules linked in: ipv6 usbhid hid ext4 jbd2 crc16 usb_storage snd_seq_dummy 
snd_hda_codec_intelhdmi snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_hda_codec_realtek snd_pcm_oss snd_mixer_oss psmouse ohci1394 snd_hda_intel 
ieee1394 i2c_i801 uhci_hcd serio_raw sg dcdbas iTCO_wdt iTCO_vendor_support 
snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc r8169 
mii ehci_hcd usbcore evdev thermal fan button battery ac cpufreq_ondemand 
acpi_cpufreq freq_table processor rtc_cmos rtc_core rtc_lib ext3 jbd mbcache 
sd_mod sr_mod cdrom pata_acpi ata_generic ata_piix libata scsi_mod i915 
i2c_algo_bit video output drm i2c_core intel_agp agpgart
Pid: 9, comm: events/0 Tainted: G        W  2.6.30-ARCH #1
Call Trace:
 [<c013b17a>] ? warn_slowpath_common+0x7a/0xc0
 [<f82be0fe>] ? drm_sysfs_hotplug_event+0x3e/0x90 [drm]
 [<f83bb410>] ? i915_hotplug_work_func+0x0/0x30 [i915]
 [<c013b237>] ? warn_slowpath_fmt+0x37/0x60
 [<f82be0fe>] ? drm_sysfs_hotplug_event+0x3e/0x90 [drm]
 [<c014f61f>] ? worker_thread+0x11f/0x280
 [<c0154900>] ? autoremove_wake_function+0x0/0x60
 [<c014f500>] ? worker_thread+0x0/0x280
 [<c0154452>] ? kthread+0x52/0x90
 [<c0154400>] ? kthread+0x0/0x90
 [<c01047c7>] ? kernel_thread_helper+0x7/0x10
---[ end trace a39351f6aee6be08 ]---

Thanks,
Alberto.
