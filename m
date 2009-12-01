Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZLAXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZLAXMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZLAXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:12:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52286 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZLAXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:12:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iC1Md+Z7HqMBxMKG8iXCFdwXzJzkhfinggYomDj1EoMKbRq8yVnW84dXZ/YUHsn2C6
         0XbWa13pqwGIo8WAoS+D8wWXoD7R+xblsBRB3YqyvYH99QMjJc+sOhTL9NYhWpGutTti
         u8ibqjqtvzA47azTtinnIJ/aKZCRfSAcdHdTY=
Message-ID: <4B15A2F6.4020206@gmail.com>
Date: Tue, 01 Dec 2009 15:12:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Kernel BUG during suspend to disk with 2.6.32-rc8-git3
References: <4B159EAC.1010006@lwfinger.net>
In-Reply-To: <4B159EAC.1010006@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/09 14:54, Larry Finger wrote:
> Using the mainline kernel git describe == v2.6.32-rc8-259-g2127816),
> I get the following BUG and WARNING:
>
> ================================
> BUG: sleeping function called from invalid context at
> drivers/acpi/acpica/psloop.c:826
> in_atomic(): 0, irqs_disabled(): 1, pid: 3616, name: s2disk
>
> 1 lock held by s2disk/3616:
>
>   #0:  (pm_mutex){+.+.+.}, at: [<ffffffff8106ee46>]
> snapshot_ioctl+0x52/0x4ba
> irq event stamp: 742026
>
> hardirqs last  enabled at (742025): [<ffffffff8125af88>]
> __mutex_unlock_slowpath+0x100/0x10b
> hardirqs last disabled at (742026): [<ffffffff8106c22e>]
> hibernation_snapshot+0xa0/0x1be
> softirqs last  enabled at (741898): [<ffffffff81041936>]
> __do_softirq+0x127/0x13d
> softirqs last disabled at (741877): [<ffffffff8100cb7c>]
> call_softirq+0x1c/0x28
> Pid: 3616, comm: s2disk Not tainted
> 2.6.32-rc8-Linus-00259-g2127816-dirty #127
> Call Trace:
>
>   [<ffffffff8105c810>] ? print_irqtrace_events+0xd0/0xd4
>   [<ffffffff81033ff9>] __might_sleep+0xef/0xf4
>   [<ffffffff81181a9c>] acpi_ps_complete_op+0x2bc/0x2d6
>   [<ffffffff8116baa5>] ? acpi_ds_exec_end_op+0x54d/0x570
>   [<ffffffff81182378>] acpi_ps_parse_loop+0x8c2/0xa4e
>   [<ffffffff8105da14>] ? trace_hardirqs_off+0xd/0xf
>   [<ffffffff810ae5ed>] ? kmem_cache_alloc+0x10e/0x147
>   [<ffffffff81181291>] acpi_ps_parse_aml+0x10a/0x3e1
>   [<ffffffff81189073>] ? acpi_ut_create_internal_object_dbg+0x22/0x87
>   [<ffffffff81182ca0>] acpi_ps_execute_method+0x22a/0x336
>   [<ffffffff8117d490>] acpi_ns_evaluate+0x18c/0x2c9
>   [<ffffffff81184230>] acpi_rs_set_srs_method_data+0xdd/0x105
>   [<ffffffff81183cfd>] acpi_set_current_resources+0x37/0x45
>   [<ffffffff81166229>] acpi_pci_link_set+0x128/0x222
>   [<ffffffff810533ab>] ? hres_timers_resume+0x3f/0x41
>   [<ffffffff81166356>] irqrouter_resume+0x33/0x4b
>   [<ffffffff811b5dc9>] __sysdev_resume+0x20/0xc0
>   [<ffffffff811b5ecc>] sysdev_resume+0x63/0xa4
>   [<ffffffff8106c29f>] hibernation_snapshot+0x111/0x1be
>   [<ffffffff8106f01d>] snapshot_ioctl+0x229/0x4ba
>   [<ffffffff8105e9bc>] ? trace_hardirqs_on_caller+0x10c/0x130
>   [<ffffffff810c0451>] vfs_ioctl+0x1d/0x82
>   [<ffffffff810c09b0>] do_vfs_ioctl+0x483/0x4c9
>   [<ffffffff810b4d9e>] ? fget_light+0xdd/0xeb
>   [<ffffffff810b4d13>] ? fget_light+0x52/0xeb
>   [<ffffffff810c0a38>] sys_ioctl+0x42/0x65
>   [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b
> ------------[ cut here ]------------
>
> WARNING: at drivers/base/sys.c:353 __sysdev_resume+0x4f/0xc0()
> Hardware name: HP Pavilion dv2700 Notebook PC
> Interrupts enabled after irqrouter_resume+0x0/0x4b
> Modules linked in: aes_x86_64 aes_generic af_packet xt_tcpudp xt_pkttype
> ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd
> nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_conservative
> cpufreq_userspace cpufreq_powersave powernow_k8 xt_NOTRACK ipt_REJECT
> xt_state iptable_raw iptable_filter nf_conntrack_netbios_ns
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables fuse
> ext3 jbd loop dm_mod snd_hda_codec_conexant arc4 ecb b43 snd_hda_intel
> mac80211 cfg80211 snd_hda_codec rfkill snd_pcm uvcvideo led_class
> videodev snd_timer v4l1_compat snd i2c_nforce2 v4l2_compat_ioctl32
> ide_cd_mod k8temp soundcore ssb serio_raw ac battery hwmon joydev sg
> forcedeth snd_page_alloc button i2c_core cdrom ext4 mbcache jbd2 crc16
> sd_mod ahci ohci_hcd libata scsi_mod ehci_hcd usbcore fan processor
> ide_pci_generic amd74xx ide_core thermal
> Pid: 3616, comm: s2disk Not tainted
> 2.6.32-rc8-Linus-00259-g2127816-dirty #127
> Call Trace:
>
>   [<ffffffff8103c789>] warn_slowpath_common+0x77/0x8f
>   [<ffffffff8103c7ee>] warn_slowpath_fmt+0x3c/0x3e
>   [<ffffffff81166323>] ? irqrouter_resume+0x0/0x4b
>   [<ffffffff811b5df8>] __sysdev_resume+0x4f/0xc0
>   [<ffffffff811b5ecc>] sysdev_resume+0x63/0xa4
>   [<ffffffff8106c29f>] hibernation_snapshot+0x111/0x1be
>   [<ffffffff8106f01d>] snapshot_ioctl+0x229/0x4ba
>   [<ffffffff8105e9bc>] ? trace_hardirqs_on_caller+0x10c/0x130
>   [<ffffffff810c0451>] vfs_ioctl+0x1d/0x82
>   [<ffffffff810c09b0>] do_vfs_ioctl+0x483/0x4c9
>   [<ffffffff810b4d9e>] ? fget_light+0xdd/0xeb
>   [<ffffffff810b4d13>] ? fget_light+0x52/0xeb
>   [<ffffffff810c0a38>] sys_ioctl+0x42/0x65
>   [<ffffffff8100b9eb>] system_call_fastpath+0x16/0x1b
> ---[ end trace 2db18c3096add170 ]---
> ==============================
>
> I do not know if this is a regression, as I just recently tried hibernation.
>
> The system has x86_64 architecture. The source is "dirty" due to a local
> modification of the rtl8187 driver, which is not even loaded.
>
> If additional info is needed, please ask.
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


looks familiar with what I'm getting
over here.
bugreport: http://bugzilla.kernel.org/show_bug.cgi?id= 14483

at the bottom reverting that commit
worked here(but still need to see
what others say).

Justin P. Mattock


