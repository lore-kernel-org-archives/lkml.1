Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZFVUCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZFVUCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:01:53 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:61075 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZFVUBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IHOD4JP/4afGw1dCJRuj6ScKHbt2WNJrIxgDFwdKs0I640jSMlhOkhAP9h40klqy3b
         gleO8NUWm+LPTzcQyAcCogx7Y29vG5dGd0uA9jaPp2nu1R709ZoUJf9Y8MuR+KYME8R0
         7AYk5WjTEn9F+xAUuA5nD9392muZmJHNHmEVQ=
Date: Mon, 22 Jun 2009 22:01:50 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: WARNING: at drivers/char/tty_ldisc.c:465 tty_ldisc_close
Message-ID: <20090622200149.GA4257@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
with current git I see the following warning when rebooting the machine:

[  287.872699] ------------[ cut here ]------------
[  287.874306] WARNING: at /home/kronos/src/linux-2.6.git/drivers/char/tty_ldisc.c:465 tty_ldisc_close+0x27/0x4d()
[  287.875829] Hardware name: F3Sa
[  287.877387] Modules linked in: af_packet btusb bridge stp llc bnep sco rfcomm l2cap bluetooth ipv6 binfmt_misc acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_ondemand freq_table kvm_intel kvm deflate zlib_deflate twofish_x86_64 twofish_common aes_x86_64 aes_generic blowfish des_generic cbc sha256_generic sha1_generic af_key ext3 jbd coretemp hwmon microcode loop snd_hda_codec_realtek arc4 ecb snd_hda_intel snd_hda_codec iwlagn snd_hwdep iwlcore snd_pcm mac80211 snd_seq snd_timer rtc_cmos snd_seq_device snd cfg80211 rtc_core soundcore video pcspkr evdev psmouse rtc_lib asus_laptop snd_page_alloc rfkill output processor battery ac button ext4 mbcache jbd2 crc16 usbhid hid dm_mod sg sr_mod cdrom sdhci_pci sdhci mmc_core ohci1394 sd_mod ieee1394 led_class ata_piix ahci uhci_hcd libata scsi_mod ehci_hcd usbcore intel_agp thermal fan unix
[  287.885243] Pid: 4098, comm: login Not tainted 2.6.30-07769-gf234012 #127
[  287.886049] Call Trace:
[  287.886858]  [<ffffffff8104eb92>] ? finish_wait+0x5d/0x65
[  287.887654]  [<ffffffff811b5daa>] ? tty_ldisc_close+0x27/0x4d
[  287.888455]  [<ffffffff8103ae06>] warn_slowpath_common+0x77/0xa4
[  287.889269]  [<ffffffff8103ae42>] warn_slowpath_null+0xf/0x11
[  287.890039]  [<ffffffff811b5daa>] tty_ldisc_close+0x27/0x4d
[  287.890814]  [<ffffffff811b5fdd>] tty_ldisc_reinit+0x15/0x4c
[  287.891581]  [<ffffffff811b66f9>] tty_ldisc_hangup+0xfd/0x188
[  287.892351]  [<ffffffff811af84d>] do_tty_hangup+0x104/0x335
[  287.893117]  [<ffffffff811afdd8>] disassociate_ctty+0x52/0x23d
[  287.893870]  [<ffffffff8103e287>] do_exit+0x2b2/0x70a
[  287.894615]  [<ffffffff8103e752>] do_group_exit+0x73/0xa0
[  287.895363]  [<ffffffff810481d7>] get_signal_to_deliver+0x380/0x3a1
[  287.896133]  [<ffffffff8100b057>] do_notify_resume+0x8b/0x70b
[  287.896887]  [<ffffffff8126e25c>] ? _spin_unlock_irqrestore+0x12/0x2b
[  287.897644]  [<ffffffff8103dd46>] ? do_wait+0x238/0x361
[  287.898398]  [<ffffffff81034766>] ? default_wake_function+0x0/0xf
[  287.899154]  [<ffffffff8103df10>] ? sys_wait4+0xa1/0xb3
[  287.899906]  [<ffffffff8100bc05>] sysret_signal+0x6d/0xb7
[  287.900669] ---[ end trace 256501a14a678d82 ]---

It's not 100% reproducible, but I have a few instances of the warning with
different (post 2.6.30) kernel builds (I tend to build daily).

Luca
