Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYIBCmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYIBCmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 22:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYIBCl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 22:41:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:4743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYIBClz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 22:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ivA9p5nJMQ9h7ItLwPRITJQbYyfACtojEZ/Pyez7TQlfSeK95Djy9Y7CU+NoY1g6bF
         ew32zhEaatfU5JfWM2PaoA9Bk1eVtCUxrGeDAoJldx1ACeqyosWodp8LyovwXyaYnf9u
         mFhDuVG+SuG6ngUPB2rz0d+eQPwHoTWyJjN2c=
Message-ID: <dd18b0c30809011941v1c79db21ra140f5c9c19dde59@mail.gmail.com>
Date: Mon, 1 Sep 2008 19:41:54 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x125/0x19e()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably not a kernel issue but a madwifi
issue, but figured I might as well post in both areas.
I am running a small test of having one computer act as a shoutcast
server with SELinux and ipsec(total lockdown), then another computer
act as a costumer
with SELinux and ipsec both with AH and ESP encryption;
Everything looks good both boxes are sending and receiving
AH and ESP encryption without any problems, except for a warning:(below)

[  748.994148] NETDEV WATCHDOG: wifi0 (ath_pci): transmit timed out
[  749.000092] ------------[ cut here ]------------
[  749.000097] WARNING: at net/sched/sch_generic.c:221
dev_watchdog+0x125/0x19e()
[  749.000101] Modules linked in: ipcomp xfrm_ipcomp btusb
cpufreq_ondemand cpufreq_performance cpufreq_powersave rfcomm hidp
l2cap bluetooth fan battery authenc esp4 aead ah4 xfrm4_mode_transport
des_generic cbc sha1_generic hmac crypto_hash crypto_null
ipmi_watchdog ipmi_msghandler uvcvideo uinput wlan_tkip
ieee80211_crypt_tkip ieee80211 ieee80211_crypt arpt_mangle
arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom
acpi_cpufreq applesmc joydev isight_firmware firewire_ohci
firewire_core wlan_scan_sta snd_hda_intel appletouch ath_rate_sample
fglrx(P) snd_pcm ohci1394 video ath_pci snd_timer thermal wlan
snd_page_alloc ieee1394 snd_hwdep processor ac ath_hal(P) agpgart
ehci_hcd uhci_hcd pata_acpi sbshc button evdev
[  749.000220] Pid: 4, comm: ksoftirqd/0 Tainted: P
2.6.27-rc5-00006-gbef69ea #14
[  749.000226]  [<c0123842>] warn_on_slowpath+0x41/0x65
[  749.000237]  [<c021bfc1>] ? _raw_spin_lock+0x53/0xd8
[  749.000246]  [<c021bf6a>] ? _raw_spin_unlock+0x74/0x78
[  749.000256]  [<f8d27e7e>] ? ath_reset+0x335/0x392 [ath_pci]
[  749.000277]  [<f8d2841b>] ? ath_tx_timeout+0xbc/0xd5 [ath_pci]
[  749.000295]  [<c012422c>] ? printk+0x15/0x17
[  749.000303]  [<c0320c25>] dev_watchdog+0x125/0x19e
[  749.000310]  [<c021bf6a>] ? _raw_spin_unlock+0x74/0x78
[  749.000318]  [<c039bd37>] ? _spin_unlock_irq+0x8/0x14
[  749.000327]  [<c011e41d>] ? finish_task_switch+0x32/0x81
[  749.000335]  [<c021bf6a>] ? _raw_spin_unlock+0x74/0x78
[  749.000342]  [<c012aad8>] run_timer_softirq+0x11e/0x180
[  749.000349]  [<c0320b00>] ? dev_watchdog+0x0/0x19e
[  749.000357]  [<c0320b00>] ? dev_watchdog+0x0/0x19e
[  749.000365]  [<c01273c4>] __do_softirq+0x6d/0xdf
[  749.000372]  [<c01275bf>] ? ksoftirqd+0x0/0xaa
[  749.000379]  [<c012747e>] do_softirq+0x48/0x57
[  749.000386]  [<c0127605>] ksoftirqd+0x46/0xaa
[  749.000392]  [<c0133453>] kthread+0x3b/0x64
[  749.000399]  [<c0133418>] ? kthread+0x0/0x64
[  749.000406]  [<c0103cbf>] kernel_thread_helper+0x7/0x10
[  749.000414]  =======================
[  749.000418] ---[ end trace 3da383d73b29b600 ]---

At first I was having internet connection, and then a few minutes
later nothing, but realized it was ipcomp that I didn't load.
When this error occurs the music is streaming, then cuts out
for a few seconds, and then back to streaming music.

In any case could be madwifi, could be the kernel,
better to send a post, than ignore it.
regards;
-- 
Justin P. Mattock
