Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbYG3JDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbYG3JDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYG3JDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:03:34 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:4227 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752835AbYG3JDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:03:32 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 05:03:31 EDT
Message-ID: <48902AD6.1010209@infracom.it>
Date: Wed, 30 Jul 2008 10:48:22 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-00000-g8be1a6d - WARNING: at drivers/base/power/main.c:82
References: <20080728113321.GA10610@infracomspa.it> <20080730011616.b68393bc.akpm@linux-foundation.org>
In-Reply-To: <20080730011616.b68393bc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 07/30/2008 10:48:21 AM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 30/07/2008 11.03.31
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15919>
X-TM-AS-Result: <No>-<-10023.223>-<5.0>-<99000>
Content-Type: multipart/mixed;
 boundary="------------030601000809030907090706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------030601000809030907090706
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

On Wed, 30 Jul 2008 01:16:16 -0700 Andrew Morton wrote:
> On Mon, 28 Jul 2008 13:33:21 +0200 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
>   
> Let's cc linux-usb, as that appears to be the subsystem which triggered
> this:
>
> int device_pm_add(struct device *dev)
> {
> 	int error;
>
> 	pr_debug("PM: Adding info for %s:%s\n",
> 		 dev->bus ? dev->bus->name : "No Bus",
> 		 kobject_name(&dev->kobj));
> 	mutex_lock(&dpm_list_mtx);
> 	if (dev->parent) {
> 		if (dev->parent->power.status >= DPM_SUSPENDING) {
> 			dev_warn(dev, "parent %s is sleeping, will not add\n",
> 				dev->parent->bus_id);
> 			WARN_ON(true);
> 		}
>
> WARN_ON.
>
> Also, I assume that your kernel did print that "parent %s is sleeping"
> message, but you trimmed it off.  That would probably be useful
> information.
>   
yep, here it is;

Jul 28 13:18:59 poppero1 kernel: [29429.039959] usb_endpoint
usbdev4.2_ep03: parent 4-2:1.1 is sleeping, will not add

BTW, looking at the syslog I realize that  5 traces  were connected
to the same event, so I'm going to attach them all, in case they're useful.

Thanks,
R.

> Thanks.
>
>   
>> [29429.039959] ------------[ cut here ]------------
>> [29429.039959] WARNING: at drivers/base/power/main.c:82
>> device_pm_add+0x4d/0xb1()
>> [29429.039959] Modules linked in: tun radeon drm rfcomm l2cap usblp ipv6
>> cpufreq_ondemand cpufreq_stats cpufreq_userspace cpufreq_powersave
>> ipt_recent xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack
>> iptable_filter ip_tables x_tables vfat fat fuse acpi_cpufreq freq_table
>> usbserial microcode snd_intel8x0m pcmcia snd_intel8x0 snd_ac97_codec
>> ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi
>> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
>> soundcore snd_page_alloc yenta_socket rsrc_nonstatic ipw2200 pcmcia_core
>> hci_usb i2c_i801 bluetooth video output battery ac button evdev usbhid
>> ohci1394 8139cp uhci_hcd ehci_hcd ieee1394 usbcore sg sr_mod cdrom
>> thermal processor fan
>> [29429.039959] Pid: 10544, comm: s2ram Tainted: G        W
>> 2.6.26-00000-g8be1a6d #1
>> [29429.039959]  [<c011b733>] warn_on_slowpath+0x40/0x63
>> [29429.039959]  [<c01e93b7>] sprintf+0x1d/0x20
>> [29429.039959]  [<c011bfc9>] vprintk+0x1cd/0x274
>> [29429.039959]  [<c011ba65>] try_acquire_console_sem+0xa/0x2a
>> [29429.039959]  [<c019e631>] sysfs_find_dirent+0x13/0x23
>> [29429.039959]  [<c019e107>] sysfs_add_file_mode+0x4c/0x6a
>> [29429.039959]  [<c019f8cd>] internal_create_group+0xda/0x139
>> [29429.039959]  [<c011c084>] printk+0x14/0x18
>> [29429.039959]  [<c023ee00>] device_pm_add+0x4d/0xb1
>> [29429.039959]  [<c023aacb>] device_add+0x340/0x4ad
>> [29429.039959]  [<f887599e>] usb_create_ep_files+0x1ed/0x26b [usbcore]
>> [29429.039959]  [<c019d850>] sysfs_hash_and_remove+0x44/0x50
>> [29429.039959]  [<f887533f>] usb_create_sysfs_intf_files+0x5a/0x72
>> [usbcore]
>> [29429.039959]  [<f887272c>] usb_set_interface+0x137/0x140 [usbcore]
>> [29429.039959]  [<f8871923>] usb_disable_interface+0x1e/0x2f [usbcore]
>> [29429.039959]  [<f88737e6>] usb_unbind_interface+0x46/0x62 [usbcore]
>> [29429.039959]  [<c023bf5d>] __device_release_driver+0x58/0x76
>> [29429.039959]  [<c023bf93>] device_release_driver+0x18/0x21
>> [29429.039959]  [<f887323f>] usb_driver_release_interface+0x3c/0x76
>> [usbcore]
>> [29429.039959]  [<f88b37b6>] hci_usb_disconnect+0x35/0x62 [hci_usb]
>> [29429.039959]  [<f88737d6>] usb_unbind_interface+0x36/0x62 [usbcore]
>> [29429.039959]  [<c023bf5d>] __device_release_driver+0x58/0x76
>> [29429.039959]  [<c023bf93>] device_release_driver+0x18/0x21
>> [29429.039959]  [<f887323f>] usb_driver_release_interface+0x3c/0x76
>> [usbcore]
>> [29429.039959]  [<f8873292>] usb_rebind_intf+0x19/0x4e [usbcore]
>> [29429.039959]  [<f887332d>] do_unbind_rebind+0x4d/0x5a [usbcore]
>> [29429.039959]  [<f887342a>] usb_external_resume_device+0xf0/0xf6
>> [usbcore]
>> [29429.039959]  [<c023ea2c>] device_resume+0x85/0x2f4
>> [29429.039959]  [<c01391c9>] suspend_devices_and_enter+0xd5/0x10d
>> [29429.039959]  [<c0139312>] enter_state+0xcf/0x11c
>> [29429.039959]  [<c01393ec>] state_store+0x8d/0xa1
>> [29429.039959]  [<c013935f>] state_store+0x0/0xa1
>> [29429.039959]  [<c01e58af>] kobj_attr_store+0x18/0x1c
>> [29429.039959]  [<c019de6f>] sysfs_write_file+0xa4/0xd8
>> [29429.039959]  [<c019ddcb>] sysfs_write_file+0x0/0xd8
>> [29429.039959]  [<c016816a>] vfs_write+0x83/0xf6
>> [29429.039959]  [<c0168597>] sys_write+0x3c/0x63
>> [29429.039959]  [<c01038da>] syscall_call+0x7/0xb
>> [29429.039959]  =======================
>> [29429.039959] ---[ end trace fa351609edb352dc ]---
>>     
>
>   


-- 
Roberto Oppedisano [RO2480-RIPE]
Infracom Network Application                   OSS and LIR Services
Tel. +39 045 8271518   Fax  +39 045 8271499   Cell. +39 348 7419534


--------------030601000809030907090706
Content-Type: application/x-gzip;
 name="trace-fa351609edb352dc.txt.gz"
Content-Disposition: inline;
 filename="trace-fa351609edb352dc.txt.gz"
Content-Transfer-Encoding: base64

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
4oNNbH8uMhnf3PwXbPGzWtpaAAA=


--------------030601000809030907090706--
