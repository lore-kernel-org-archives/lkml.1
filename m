Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbYDTTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbYDTTON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYDTTN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:13:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbYDTTNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:13:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Sun, 20 Apr 2008 21:14:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl>
In-Reply-To: <200804202104.24037.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200804202114.35974.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 of April 2008, Rafael J. Wysocki wrote:
> Hi,
> 
> I've just got the following traces from 2.6.25-git2 on HP nx6325 (64-bit).
> I think they are related to the hang I described yesterday:
> 
> [12844.066757] BUG: unable to handle kernel paging request at ffffffffffffffff
> [12844.066765] IP: [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
> [12844.066775] PGD 203067 PUD 204067 PMD 0 
> [12844.066778] Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> [12844.066782] CPU 1 
> [12844.066784] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hotplug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbc
>  ore edd ext3 jbd atiixp ide_core
> [12844.066854] Pid: 13078, comm: kio_file Tainted: G   M     2.6.25 #401
> [12844.066857] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117

That is line 1250 in fs/dcache.c, btw:

(gdb) l *__d_lookup+0xf1
0xffffffff802a7b3c is in __d_lookup (/home/rafael/src/linux-2.6/fs/dcache.c:1250).
1245            struct hlist_node *node;
1246            struct dentry *dentry;
1247
1248            rcu_read_lock();
1249
1250            hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
1251                    struct qstr *qstr;
1252
1253                    if (dentry->d_name.hash != hash)
1254                            continue;

