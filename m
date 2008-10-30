Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYJ3Vtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYJ3Vtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbYJ3Vs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:48:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:12913 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbYJ3Vp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ugrZn2bdbnjpkAfSnYfn74FPAbujz+RTrKAAsqw6Cgdd6hOICRg4xx5HMwIlRRq/cb
         4D4BHRb2RAsV1LQRwpfjYgnRn/+zf42nbRoet92bGNMxntM4qHipYlJpbd4lFgLj0l+M
         oJnL+voRazI5Sh/UwQZcP6NaQqFaunANsC4Gg=
Message-ID: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com>
Date: Thu, 30 Oct 2008 14:45:27 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tim Gardner" <tim.gardner@canonical.com>,
       "Tomas Winkler" <tomasw@gmail.com>,
       "reinette chatre" <reinette.chatre@linux.intel.com>
Subject: [MEMO] ftrace suckage++
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As johannes pointed out to me the culprit to the e1000e corruption was
determined to be ftrace related [1]. Well it seems I hit an oops with
ftrace using iwlagn after a simple load of the module using
wireless-testing. I'm not sure if john's tree yet has ftrace fixes.
Both Fedora 10 and Ubuntu 8.10 had dynamic ftrace enabled so users on
these first kernels and using compat-wireless may run into this so
just putting this out there. I'll can check for this flag in
compat-wireless for now and bitch/exit if its enabled unless someone
has a better idea.

[1] http://lwn.net/Articles/303390/

Oops, using wireless-testing and iwlagn with these options enabled:

CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y


[  294.209022] BUG: soft lockup - CPU#1 stuck for 61s! [insmod:9196]
[  294.209022] Modules linked in: iwlcore mac80211 cfg80211 af_packet
binfmt_misc rfcomm l2cap uinput ipv6 acpi_cpufreq cpufreq_userspace
cpufreq_conservative cpufreq_ondemand cpufreq_powersave cpufreq_stats
freq_table pci_slot sbs sbshc container iptable_filter ip_tables
x_tables
sbp2 snd_hda_intel joydev snd_pcm_oss arc4 snd_mixer_oss ecb snd_pcm
snd_seq_dummy snd_seq_oss pcmcia snd_seq_midi sdhci_pci sdhci psmouse
serio_raw yenta_socket rsrc_nonstatic pcmcia_core ricoh_mmc mmc_core
snd_rawmidi iTCO_wdt iTCO_vendor_support btusb bluetooth ac battery
video
output snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
pci_hotplug snd soundcore wmi snd_page_alloc intel_agp agpgart button
thinkpad_acpi rfkill hwmon led_class evdev nvram ext3 jbd mbcache
sr_mod cdrom sg ata_piix sd_mod crc_t10dif pata_acpi ohci1394 ieee1394
ata_generic ahci libata scsi_mod ehci_hcd uhci_hcd e1000e usbcore
thermal processor fan fuse [last unloaded: cfg80211]
[  294.209022] irq event stamp: 208522
[  294.209022] hardirqs last  enabled at (208521): [<c02674ac>]
trace_hardirqs_on_thunk+0xc/0x10
[  294.209022] hardirqs last disabled at (208522): [<c02674bc>]
trace_hardirqs_off_thunk+0xc/0x10
[  294.209022] softirqs last  enabled at (208520): [<c013b39b>]
__do_softirq+0x13b/0x190
[  294.209022] softirqs last disabled at (208511): [<c013b47d>]
do_softirq+0x8d/0xa0
[  294.209022]
[  294.209022] Pid: 9196, comm: insmod Not tainted (2.6.28-rc2-wl #9) 6460DWU
[  294.209022] EIP: 0060:[<c018c96d>] EFLAGS: 00000282 CPU: 1
[  294.209022] EIP is at ftrace_record_ip+0x9d/0x1d0
[  294.209022] EAX: c209a068 EBX: f80d9c36 ECX: 03380000 EDX: c2714738
[  294.209022] ESI: c054cda0 EDI: c092d4f8 EBP: f2311e0c ESP: f2311dec
[  294.209022]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  294.209022] CR0: 8005003b CR2: b7c4e007 CR3: 32222000 CR4: 00000690
[  294.209022] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  294.209022] DR6: ffff0ff0 DR7: 00000400
[  294.209022] Call Trace:
[  294.209022]  [<c018cdff>] ftrace_convert_nops+0x2f/0xd0
[  294.209022]  [<c018ceb6>] ftrace_init_module+0x16/0x20
[  294.209022]  [<c01671fc>] load_module+0x15dc/0x1c10
[  294.209022]  [<c019608c>] ? generic_file_aio_read+0x24c/0x6b0
[  294.209022]  [<c015cecb>] ? trace_hardirqs_on+0xb/0x10
[  294.209022]  [<c0394da4>] ? mutex_lock_interruptible_nested+0x274/0x340
[  294.209022]  [<c0167883>] sys_init_module+0x53/0x1b0
[  294.209022]  [<c015ce65>] ? trace_hardirqs_on_caller+0x115/0x170
[  294.209022]  [<c02674ac>] ? trace_hardirqs_on_thunk+0xc/0x10
[  294.209022]  [<c010407b>] sysenter_do_call+0x12/0x3f

  Luis
