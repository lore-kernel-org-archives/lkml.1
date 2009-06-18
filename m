Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZFRVXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZFRVXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFRVW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:22:56 -0400
Received: from rosi.naasa.net ([212.8.0.13]:41156 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZFRVWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:22:55 -0400
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [2.6.30] Kernel bug with dock driver
Date: Thu, 18 Jun 2009 23:22:52 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906142100.48621.jplatte@naasa.net> <200906161125.00685.jplatte@naasa.net> <20090617123440.GA400@khazad-dum.debian.net>
In-Reply-To: <20090617123440.GA400@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906182322.54566.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday, 17. June 2009 schrieb Henrique de Moraes Holschuh:
Hi Henrique,

> If it causes a NULL derreference, it means someone has changed API and did
> NOT change all callsites.  It is that simple.
>
> Joerg, please apply this patch, and report the results...  WARNING: you
> will not get bay events from thinkpad-acpi, so be careful to not remove
> from the bay a device that is still active...

This time I got two BUGs while being on battery and without acpid:

------------[ cut here ]------------
WARNING: at drivers/platform/x86/thinkpad_acpi.c:4565 bay_notify+0x35/0x5e 
[thinkpad_acpi]()
Hardware name: 2373G1G
thinkpad_acpi: dev_name() is returning NULL
Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs radeon drm 
sco bridge stp llc bnep l2cap bluetooth ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT ipt_LOG xt_limit 
xt_tcpudp xt_mac xt_multiport iptable_filter iptable_mangle ip_tables x_tables 
nf_conntrack_ftp nf_conntrack vboxdrv binfmt_misc af_packet cpufreq_userspace 
cpufreq_stats cpufreq_powersave autofs4 nsc_ircc fuse nls_utf8 ntfs nls_base 
ext2 deadline_iosched as_iosched ircomm_tty ircomm tun acpi_cpufreq sbs sbshc 
joydev snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device irtty_sir thinkpad_acpi ipw2200 libipw 
yenta_socket sir_dev rfkill snd rsrc_nonstatic lib80211 soundcore pcmcia 
rtc_cmos psmouse led_class pcmcia_core snd_page_alloc i2c_i801 rng_core 
8250_pci irda pcspkr serio_raw nvram parport_pc 8250_pnp rtc_core parport 
button rtc_lib processor battery ac crc_ccitt 8250 serial_core evdev ext3 jbd 
mbcache sd_mod ata_generic pata_acpi ata_piix libata uhci_hcd ehci_hcd e1000 
scsi_mod usbcore intel_agp agpgart video output thermal fan unix 
cpufreq_conservative cpufreq_ondemand freq_table radeonfb fb_ddc backlight 
i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fbcon tileblit font 
bitblit softcursor fb
Pid: 52, comm: kacpi_notify Not tainted 2.6.30 #1
Call Trace:
 [<c011f839>] warn_slowpath_common+0x60/0x90
 [<f9767132>] ? bay_notify+0x0/0x5e [thinkpad_acpi]
 [<c011f89d>] warn_slowpath_fmt+0x24/0x27
 [<f9767167>] bay_notify+0x35/0x5e [thinkpad_acpi]
 [<f9767023>] dispatch_acpi_notify+0x23/0x26 [thinkpad_acpi]
 [<c02018cd>] acpi_ev_notify_dispatch+0x4c/0x57
 [<c01f4488>] acpi_os_execute_deferred+0x20/0x2c
 [<c012cff6>] worker_thread+0x15a/0x1fd
 [<c01f4468>] ? acpi_os_execute_deferred+0x0/0x2c
 [<c012fc7d>] ? autoremove_wake_function+0x0/0x33
 [<c012ce9c>] ? worker_thread+0x0/0x1fd
 [<c012f8bc>] kthread+0x42/0x67
 [<c012f87a>] ? kthread+0x0/0x67
 [<c01030d3>] kernel_thread_helper+0x7/0x10
---[ end trace 0469584017b9bddb ]---
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
ata2.00: disabled
ACPI: \_SB_.PCI0.IDE0.SCND.MSTR - undocking
ACPI Warning (nspredef-0290): \_SB_.PCI0.LPC_.EC__.BEEP: Excess arguments - 
needs 1, found 2 [20090320]
------------[ cut here ]------------
WARNING: at drivers/platform/x86/thinkpad_acpi.c:4565 bay_notify+0x35/0x5e 
[thinkpad_acpi]()
Hardware name: 2373G1G
thinkpad_acpi: dev_name() is returning NULL
Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs radeon drm 
sco bridge stp llc bnep l2cap bluetooth ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT ipt_LOG xt_limit 
xt_tcpudp xt_mac xt_multiport iptable_filter iptable_mangle ip_tables x_tables 
nf_conntrack_ftp nf_conntrack vboxdrv binfmt_misc af_packet cpufreq_userspace 
cpufreq_stats cpufreq_powersave autofs4 nsc_ircc fuse nls_utf8 ntfs nls_base 
ext2 deadline_iosched as_iosched ircomm_tty ircomm tun acpi_cpufreq sbs sbshc 
joydev snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device irtty_sir thinkpad_acpi ipw2200 libipw 
yenta_socket sir_dev rfkill snd rsrc_nonstatic lib80211 soundcore pcmcia 
rtc_cmos psmouse led_class pcmcia_core snd_page_alloc i2c_i801 rng_core 
8250_pci irda pcspkr serio_raw nvram parport_pc 8250_pnp rtc_core parport 
button rtc_lib processor battery ac crc_ccitt 8250 serial_core evdev ext3 jbd 
mbcache sd_mod ata_generic pata_acpi ata_piix libata uhci_hcd ehci_hcd e1000 
scsi_mod usbcore intel_agp agpgart video output thermal fan unix 
cpufreq_conservative cpufreq_ondemand freq_table radeonfb fb_ddc backlight 
i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect fbcon tileblit font 
bitblit softcursor fb
Pid: 52, comm: kacpi_notify Tainted: G        W  2.6.30 #1
Call Trace:
 [<c011f839>] warn_slowpath_common+0x60/0x90
 [<f9767132>] ? bay_notify+0x0/0x5e [thinkpad_acpi]
 [<c011f89d>] warn_slowpath_fmt+0x24/0x27
 [<f9767167>] bay_notify+0x35/0x5e [thinkpad_acpi]
 [<f9767023>] dispatch_acpi_notify+0x23/0x26 [thinkpad_acpi]
 [<c02018cd>] acpi_ev_notify_dispatch+0x4c/0x57
 [<c01f4488>] acpi_os_execute_deferred+0x20/0x2c
 [<c012cff6>] worker_thread+0x15a/0x1fd
 [<c01f4468>] ? acpi_os_execute_deferred+0x0/0x2c
 [<c012fc7d>] ? autoremove_wake_function+0x0/0x33
 [<c012ce9c>] ? worker_thread+0x0/0x1fd
 [<c012f8bc>] kthread+0x42/0x67
 [<c012f87a>] ? kthread+0x0/0x67
 [<c01030d3>] kernel_thread_helper+0x7/0x10
---[ end trace 0469584017b9bddc ]---

Hope it helps...

Best regards,
Jörg
