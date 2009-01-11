Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZAKT6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZAKT6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZAKT6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:58:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49727 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZAKT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:58:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tBZmY7oWPKWXKuz5cMbFcOvU2cXJCxPsSfEP4JTeFyLCCxstuFPgdpZvapLDG/iSmH
         6QmokeGiYauRLsyU6RUEf8Hk2k+O0vq/sz3IMqLm/ydj6a7D/6x/t1cuFc9FqGpZb9EO
         u3R6y04ECIa6tf+Uq8dl5G62ZsqqJCtoZpdcE=
Message-ID: <c4e36d110901111158u6a9c0f82wad1441ab3f1db182@mail.gmail.com>
Date: Sun, 11 Jan 2009 20:58:02 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH] libata: use WARN_ON_ONCE on hot paths
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Tejun Heo" <tj@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <496799C8.1060804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
	 <49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org>
	 <4966974B.3090700@gmail.com> <49672166.4050606@gmail.com>
	 <496724A2.5030400@kernel.org>
	 <c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>
	 <49673D02.6000002@garzik.org>
	 <20090109120730.5c80fc68@lxorguk.ukuu.org.uk>
	 <496799C8.1060804@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've booted  2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)

This time I've got only this warning:


input: ThinkPad Extra Buttons as /devices/virtual/input/input5
Driver 'sr' needs updating - please use bus_type methods
------------[ cut here ]------------
WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x6b0/0x7f0()
Hardware name: 6464CTO
Modules linked in: sr_mod(+) cdrom thinkpad_acpi rfkill backlight
nvram button led_class battery intel_agp ac uhci_hcd ohci_hcd ehci_hcd
usbcore [last unloaded: scsi_wait_scan]
Pid: 1150, comm: udevd Not tainted 2.6.29-rc1 #6
Call Trace:
 <IRQ>  [<ffffffff80244d8f>] warn_slowpath+0xaf/0x110
 [<ffffffff8026fdc9>] ? __lock_acquire+0x5e9/0x1db0
 [<ffffffff80472316>] ? ata_sff_data_xfer32+0xa6/0xe0
 [<ffffffff80471b90>] ata_sff_hsm_move+0x6b0/0x7f0
 [<ffffffff80472029>] ata_sff_interrupt+0x1a9/0x2b0
 [<ffffffff80294ee5>] handle_IRQ_event+0x35/0x70
 [<ffffffff8029675c>] handle_edge_irq+0xbc/0x160
 [<ffffffff8020ec55>] do_IRQ+0xb5/0x1b0
 [<ffffffff8020cf53>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace 701c93e34e726fd9 ]---
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:sr0
PM: Adding info for No Bus:11:0
sr 3:0:0:0: Attached scsi CD-ROM sr0


Zdenek
