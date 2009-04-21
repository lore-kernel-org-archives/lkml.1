Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZDUVgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZDUVgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZDUVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:35:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42967 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZDUVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=psLwyHl5hHIyJAKMeW+dfgQJOnEH1FaL7+9R4QTn20YPmEDoBP2dwxgVmjGPQfKiN0
         /Wnit8kpFdV14CzRKK3+MKjJSO0TVXWUeSYQPsiStH6h2nb423gBOYaCnhMt9CtY5VnK
         LTLf4hk0kEIZOCQQ1/wXrXRkaVWxdz/MbyTwM=
Message-ID: <49EE3C1E.8070208@gmail.com>
Date: Tue, 21 Apr 2009 23:35:26 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I get the following when I switch from runlevel 5 to 3 using the latest
git kernel. I haven't noticed any other side-effects and X started up
fine, but I'm assuming something is misbehaving and the trace might be
meaningful to someone. I also frequently still notice this "*ERROR*
trying to get vblank count for disabled pipe 0" message when I exit
Xorg. (BTW, I am still using EXA acceleration due to issues with UXA+KMS).

The hardware is an Lenovo Thinkpad W500 with:
     00:02.1 Display controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)

messages:
Apr 21 00:44:00 linux-7vph init: Switching to runlevel: 3
Apr 21 00:44:06 linux-7vph kernel: ------------[ cut here ]------------
Apr 21 00:44:06 linux-7vph kernel: WARNING: at
drivers/gpu/drm/i915/i915_gem.c:3823 i915_gem_idle+0x17a/0x28c [i915]()
Apr 21 00:44:06 linux-7vph kernel: Hardware name: 40622XG
Apr 21 00:44:06 linux-7vph kernel: Modules linked in: iwlagn rndis_wlan
rndis_host cdc_ether usbnet cdc_acm mii usbhid hid cpufreq_stats tun
i915 drm i2c_algo_bit af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG
xt_limit snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc ip6t_REJECT
nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state
iptable_raw iptable_filter ip6table_mangle cpufreq_conservative
cpufreq_userspace nf_conntrack_netbios_ns cpufreq_powersave
nf_conntrack_ipv4 acpi_cpufreq nf_conntrack nf_defrag_ipv4 ip_tables
speedstep_lib ip6table_filter ip6_tables x_tables ipv6 microcode fuse
loop dm_mod snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device
snd_hda_codec_conexant arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep
snd_pcm iwlcore snd_timer thinkpad_acpi snd mac80211 soundcore rtc_cmos
video rfkill led_class intel_agp iTCO_wdt output rtc_core snd_page_alloc
ohci1394 i2c_i801 button sr_mod wmi battery ac e1000e rtc_lib agpgart
cfg80211 nvram joydev i2c_core cdrom iTCO_vendor_support sg ieee1394
sd_mod us
Apr 21 00:44:06 linux-7vph kernel: bcore ext4 jbd2 crc16 edd ext3
mbcache jbd fan ahci libata scsi_mod thermal processor [last unloaded:
iwlagn]
Apr 21 00:44:06 linux-7vph kernel: Pid: 3193, comm: Xorg Not tainted
2.6.30-rc2-pae #24
Apr 21 00:44:06 linux-7vph kernel: Call Trace:
Apr 21 00:44:06 linux-7vph kernel:  [<c0127768>] warn_slowpath+0x71/0xa0
Apr 21 00:44:06 linux-7vph kernel:  [<c012f66f>] ? del_timer_sync+0xd/0x18
Apr 21 00:44:06 linux-7vph kernel:  [<c030573c>] ?
schedule_timeout+0x154/0x16a
Apr 21 00:44:06 linux-7vph kernel:  [<c01354f3>] ?
__cancel_work_timer+0x124/0x162
Apr 21 00:44:06 linux-7vph kernel:  [<f82df3ba>] ?
i915_gem_retire_requests+0x141/0x15b [i915]
Apr 21 00:44:06 linux-7vph kernel:  [<f82e07e2>]
i915_gem_idle+0x17a/0x28c [i915]
Apr 21 00:44:06 linux-7vph kernel:  [<f82e0947>]
i915_gem_leavevt_ioctl+0x1f/0x2e [i915]
Apr 21 00:44:06 linux-7vph kernel:  [<f828574c>] drm_ioctl+0x1f6/0x27c [drm]
Apr 21 00:44:06 linux-7vph kernel:  [<f82e0928>] ?
i915_gem_leavevt_ioctl+0x0/0x2e [i915]
Apr 21 00:44:06 linux-7vph kernel:  [<c0305dc0>] ? mutex_lock+0xe/0x28
Apr 21 00:44:06 linux-7vph kernel:  [<f7ee5640>] ?
agpioc_release_wrap+0x57/0x5b [agpgart]
Apr 21 00:44:06 linux-7vph kernel:  [<f7ee6279>] ? agp_ioctl+0x3b6/0x3d9
[agpgart]
Apr 21 00:44:06 linux-7vph kernel:  [<c013ef0f>] ? getnstimeofday+0x51/0xda
Apr 21 00:44:06 linux-7vph kernel:  [<c0196b3a>] vfs_ioctl+0x50/0x69
Apr 21 00:44:06 linux-7vph kernel:  [<c0196fac>] do_vfs_ioctl+0x459/0x492
Apr 21 00:44:06 linux-7vph kernel:  [<c01047fe>] ? timer_interrupt+0x3a/0x41
Apr 21 00:44:06 linux-7vph kernel:  [<c0158a2a>] ?
handle_IRQ_event+0x8c/0x142
Apr 21 00:44:06 linux-7vph kernel:  [<c0306e6f>] ? _spin_lock+0x8/0xb
Apr 21 00:44:06 linux-7vph kernel:  [<c0159d5a>] ?
handle_edge_irq+0x108/0x111
Apr 21 00:44:06 linux-7vph kernel:  [<c012bcaa>] ? __do_softirq+0x12b/0x133
Apr 21 00:44:06 linux-7vph kernel:  [<c0197025>] sys_ioctl+0x40/0x5a
Apr 21 00:44:06 linux-7vph kernel:  [<c01029d4>] sysenter_do_call+0x12/0x28
Apr 21 00:44:06 linux-7vph kernel: ---[ end trace e40fb1797bec2bee ]---
Apr 21 00:44:06 linux-7vph kernel: [drm:gm45_get_vblank_counter] *ERROR*
trying to get vblank count for disabled pipe 0
Apr 21 00:44:10 linux-7vph bonobo-activation-server (niella-19973):
could not associate with desktop session: Failed to connect to socket
/tmp/dbus-uxRGFTgO2e: Connection refused
Apr 21 00:44:31 linux-7vph init: Switching to runlevel: 5

Regards,
Niel
