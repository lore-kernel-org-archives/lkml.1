Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbYHIHqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbYHIHqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYHIHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:45:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:41200 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYHIHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=KHcWxoV41LumW1wJHk63vM2LAUhHXfTmVrww/R5xIl28H2qG7eYiXQIUL0qqcm6OZg
         vGKu9kUw7ZAPXc/9rrubXaSCq7CdMkndCP/a2y4vjOC38Vp+L/PIl28unxCBMsivKi7I
         vhNDROZ3Wrl0o0FF2YcSUn7kXO7o3xWBNW3+k=
To: Rabin Vincent <rabin@rab.in>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000010
Date: Sat, 9 Aug 2008 10:12:47 +0200
User-Agent: KMail/1.9.9
Cc: Walter Franzini <walter.franzini@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <86wsis0xq0.fsf@acer.nord-com.it> <20080808234016.GA11101@debian>
In-Reply-To: <20080808234016.GA11101@debian>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808091012.48196.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Rabin Vincent wrote:
> (cc linux-wireless)
> 
> On Fri, Aug 08, 2008 at 09:31:19AM +0200, Walter Franzini wrote:
> > Hi,
> > 
> > I have the following trace with 2.6.26.1, it seems to be related to a
> > wireless usb adapter that works with 2.6.25.x
> > 
> > My "feeling" is that such usb adapter works well with 2.6.25.x and
> > does not work with 2.6.26.x.

Patch to fix this issue has been send upstream (stable).
	rt2x00: Fix OOPS on failed creation of rt2x00lib workqueue

Please note that a workaround is blacklisting rt2500usb and loading
rt73usb directly. (The bug is triggered because rt2500usb is loaded for
a USB device which does not contain rt 2500usb chipset).

Ivo

> > ------------------------------------------------------------------------
> > phy1 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
> > phy1 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 00000010
> > IP: [<c012c550>] flush_workqueue+0xa/0x3f
> > *pde = 00000000
> > Oops: 0000 [#1] PREEMPT SMP
> > Modules linked in: rt2500usb(+) rt2x00usb rt2x00lib usbhid hid xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables ppdev lp fuse sbp2 acpi_cpufreq freq_table arc4 ecb crypto_blkcipher pcmcia joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm iwl3945 snd_timer iTCO_wdt intel_agp firmware_class snd yenta_socket rsrc_nonstatic sg i2c_i801 agpgart mac80211 container soundcore wmi serio_raw parport_pc pcspkr pcmcia_core irda ac evdev battery button parport psmouse i2c_core cfg80211 snd_page_alloc crc_ccitt sr_mod cdrom ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod sd_mod ata_piix ata_generic ohci1394 libata scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore e1000 dock thermal processor fan
> > 
> > Pid: 4312, comm: modprobe Not tainted (2.6.26.1-1 #1)
> > EIP: 0060:[<c012c550>] EFLAGS: 00010246 CPU: 0
> > EIP is at flush_workqueue+0xa/0x3f
> > EAX: 00000000 EBX: f7ea1020 ECX: f7d4c000 EDX: 00000000
> > ESI: c035e7ec EDI: 00000000 EBP: f7e0a200 ESP: f7d4dea8
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process modprobe (pid: 4312, ti=f7d4c000 task=f7e86730 task.ti=f7d4c000)
> > Stack: f7ea1020 f7ea1020 f7ea01a0 f8cb81ee ffffffed f8cb8b65 f7ea1020 00000282
> >        f8c93091 000080d0 f7ea1020 f8cc92e0 f7ea1020 00000000 f7ea01a0 f7e0a200
> >        f8c9389c f79e2400 f7e0a200 f8ccaa2c 00000000 f8cca7e0 f8860880 f79e2400
> > Call Trace:
> >  [<f8cb81ee>] rt2x00lib_remove_dev+0x1f/0x40 [rt2x00lib]
> >  [<f8cb8b65>] rt2x00lib_probe_dev+0x2f5/0x311 [rt2x00lib]
> >  [<f8c93091>] rt2x00usb_alloc_reg+0x46/0x7e [rt2x00usb]
> >  [<f8c9389c>] rt2x00usb_probe+0xc6/0x101 [rt2x00usb]
> >  [<f8860880>] usb_probe_interface+0xac/0xdd [usbcore]
> >  [<c022b308>] __driver_attach+0x0/0x55
> >  [<c022b291>] driver_probe_device+0xb5/0x12c
> >  [<c022b33f>] __driver_attach+0x37/0x55
> >  [<c022ab49>] bus_for_each_dev+0x34/0x56
> >  [<c022b12c>] driver_attach+0x11/0x13
> >  [<c022b308>] __driver_attach+0x0/0x55
> >  [<c022ae9f>] bus_add_driver+0x8a/0x1a7
> >  [<c01ccd56>] kset_find_obj+0x4f/0x56
> >  [<c022b495>] driver_register+0x6d/0xc1
> >  [<f88604e0>] usb_register_driver+0x5d/0xb4 [usbcore]
> >  [<c013caa9>] sys_init_module+0x84/0x173
> >  [<c010386d>] sysenter_past_esp+0x6a/0x91
> >  [<c02a0000>] quirk_e100_interrupt+0x33/0x154
> >  =======================
> > Code: 00 74 14 e8 90 ff ff ff 8b 43 20 e8 6e 24 00 00 c7 43 20 00 00 00 00 5b c3 83 c0 10 e9 0d ac fe ff 57 89 c7 56 be ec e7 35 c0 53 <83> 78 10 00 b8 f0 e7 35 c0 0f 44 f0 89 f0 e8 ca f8 09 00 eb 15
> > EIP: [<c012c550>] flush_workqueue+0xa/0x3f SS:ESP 0068:f7d4dea8
> > ---[ end trace 009005218430c5d0 ]---
> > ------------------------------------------------------------------------
> > 
> > Thanks.
> > --
> > Walter Franzini
> > http://aegis.stepbuild.org/
> > 
> > PGP Public key ID: 1024D/CB3FEB43
> > Key fingerprint  : FA26 C33B CAFF 7848 EFEB  7327 96AA 2D57 CB3F EB43
> > Key server       : http://www.keyserver.net
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


