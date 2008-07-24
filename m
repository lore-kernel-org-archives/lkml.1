Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYGXWtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYGXWtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:49:34 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51216 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884AbYGXWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:49:33 -0400
Date: Fri, 25 Jul 2008 00:49:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080725004926.5f201c70@mjolnir.drzeus.cx>
In-Reply-To: <20080724222914.GG5307@ldl.fc.hp.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
	<200807241407.18543.jbarnes@virtuousgeek.org>
	<20080724235127.40bd0ac9@mjolnir.drzeus.cx>
	<200807241506.58973.jbarnes@virtuousgeek.org>
	<20080724222914.GG5307@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11917-1216939771-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11917-1216939771-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 16:29:14 -0600
Alex Chiang <achiang@hp.com> wrote:

> * Jesse Barnes <jbarnes@virtuousgeek.org>:
> >=20
> > Theoretically only one of the other hotplug drivers could claim
> > the slot (e.g.  acpi, cpci, cpqhp, fakephp etc.).  You could
> > put a dump_stack() or something into
> > drivers/pci/hotplug/pci_hotplug_core.c:pci_hp_register to see
> > if we're getting multiple callers on the same slot for some
> > reason...  Maybe the pciehp driver itself is trying to register
> > the same slot twice?
>=20
> This is a good idea.
>=20
> Any chance you could get that debug info for us, Pierre?
>=20

I aim to please. Following is the relevant lines from my bootup with a
dump_stack() right at the beginning of pci_hp_register():

[    1.247459] pcieport-driver 0000:00:01.0: found MSI capability
[    1.247523] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.247632] pci_express 0000:00:01.0:pcie02: allocate port service
[    1.247741] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.248010] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.248158] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.248299] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.248415] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.248524] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.248873] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.249020] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.249162] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.249270] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.249379] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.249708] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.249855] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.249995] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.250102] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.250211] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.250531] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    1.250679] pcieport-driver 0000:00:1c.3: found MSI capability
[    1.250819] pci_express 0000:00:1c.3:pcie00: allocate port service
[    1.250927] pci_express 0000:00:1c.3:pcie02: allocate port service
[    1.251035] pci_express 0000:00:1c.3:pcie03: allocate port service
[    1.251361] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    1.251508] pcieport-driver 0000:00:1c.4: found MSI capability
[    1.251649] pci_express 0000:00:1c.4:pcie00: allocate port service
[    1.251762] pci_express 0000:00:1c.4:pcie02: allocate port service
[    1.251894] pci_express 0000:00:1c.4:pcie03: allocate port service
[    1.252429] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.253405] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did 0
[    1.253453] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.253460]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.253475]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.253485]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.253494]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.253502]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.253513]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.253523]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.253531]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.253540]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.253550]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.253557]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.253569]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.253578]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.253585]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.253593]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.253600]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.253608]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.253615]  [<c059f8be>] driver_register+0x6e/0x150
[    1.253622]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.253630]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.253638]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.253648]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.253657]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.253666]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.253676]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.253685]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.253695]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.253704]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.253712]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.253720]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.253728]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.253841] hpdriver 0000:00:01.0:pcie02: service driver hpdriver loaded
[    1.254648] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did 0
[    1.254730] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.254735]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.254744]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.254754]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.254763]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.254771]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.254780]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.254789]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.254797]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.254806]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.254814]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.254821]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.254830]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.254838]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.254845]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.254853]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.254859]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.254867]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.254874]  [<c059f8be>] driver_register+0x6e/0x150
[    1.254881]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.254889]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.254897]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.254905]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.254914]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.254922]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.254930]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.254939]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.254948]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.254956]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.254964]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.254972]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.254980]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.255097] hpdriver 0000:00:1c.0:pcie02: service driver hpdriver loaded
[    1.255900] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 ss_did 0
[    1.255989] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.255994]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.256004]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.256013]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.256023]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.256030]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.256040]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.256049]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.256057]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.256066]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.256074]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.256082]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.256092]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.256100]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.256107]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.256114]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.256121]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.256129]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.256136]  [<c059f8be>] driver_register+0x6e/0x150
[    1.256143]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.256151]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.256159]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.256167]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.256176]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.256184]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.256192]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.256201]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.256209]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.256218]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.256226]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.256234]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.256242]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.256355] hpdriver 0000:00:1c.1:pcie02: service driver hpdriver loaded
[    1.257191] pciehp: HPC vendor_id 8086 device_id 2843 ss_vid 0 ss_did 0
[    1.257273] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.257278]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.257287]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.257297]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.257306]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.257313]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.257323]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.257332]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.257340]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.257349]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.257358]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.257365]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.257374]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.257383]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.257390]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.257397]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.257403]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.257411]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.257419]  [<c059f8be>] driver_register+0x6e/0x150
[    1.257426]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.257434]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.257442]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.257450]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.257459]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.257467]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.257475]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.257484]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.257492]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.257500]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.257509]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.257517]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.257524]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.257639] hpdriver 0000:00:1c.2:pcie02: service driver hpdriver loaded
[    1.258440] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 ss_did 0
[    1.258522] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.258527]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.258537]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.258546]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.258556]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.258564]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.258573]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.258583]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.258591]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.258600]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.258609]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.258616]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.258626]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.258634]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.258642]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.258649]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.258656]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.258665]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.258672]  [<c059f8be>] driver_register+0x6e/0x150
[    1.258679]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.258687]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.258695]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.258703]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.258712]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.258719]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.258728]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.258737]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.258745]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.258753]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.258761]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.258769]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.258777]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.258893] hpdriver 0000:00:1c.3:pcie02: service driver hpdriver loaded
[    1.259701] pciehp: HPC vendor_id 8086 device_id 2847 ss_vid 0 ss_did 0
[    1.259787] Pid: 1, comm: swapper Not tainted 2.6.26 #110
[    1.259791]  [<c0544545>] pci_hp_register+0x25/0x4b0
[    1.259801]  [<c0545e3e>] ? get_adapter_status+0x2e/0x70
[    1.259810]  [<c05462ad>] ? pciehp_probe+0xbd/0x3f0
[    1.259819]  [<c054631b>] pciehp_probe+0x12b/0x3f0
[    1.259827]  [<c04e8b58>] ? sysfs_add_one+0x18/0x50
[    1.259836]  [<c04e9a94>] ? sysfs_do_create_link+0xa4/0x140
[    1.259845]  [<c0542110>] pcie_port_probe_service+0x50/0x90
[    1.259853]  [<c04e9b67>] ? sysfs_create_link+0x17/0x20
[    1.259862]  [<c059f42d>] ? driver_sysfs_add+0x5d/0x90
[    1.259870]  [<c059f557>] driver_probe_device+0x87/0x1a0
[    1.259877]  [<c066f841>] ? _spin_lock_irqsave+0x21/0x40
[    1.259886]  [<c066fb66>] ? _spin_unlock_irqrestore+0x16/0x40
[    1.259894]  [<c059f6e9>] __driver_attach+0x79/0x80
[    1.259901]  [<c059ee23>] bus_for_each_dev+0x53/0x80
[    1.259908]  [<c059f3ce>] driver_attach+0x1e/0x20
[    1.259915]  [<c059f670>] ? __driver_attach+0x0/0x80
[    1.259923]  [<c059e7e7>] bus_add_driver+0x1b7/0x230
[    1.259930]  [<c059f8be>] driver_register+0x6e/0x150
[    1.259937]  [<c059f8be>] ? driver_register+0x6e/0x150
[    1.259945]  [<c054202f>] pcie_port_service_register+0x3f/0x50
[    1.259954]  [<c07a7b52>] pcied_init+0x16/0x83
[    1.259962]  [<c07a7b38>] ? pci_hotplug_init+0x1f/0x23
[    1.259971]  [<c078b417>] kernel_init+0x1ad/0x2b8
[    1.259978]  [<c04ae774>] ? sys_select+0x44/0x1a0
[    1.259987]  [<c07a7b3c>] ? pcied_init+0x0/0x83
[    1.259996]  [<c042337f>] ? schedule_tail+0x1f/0x50
[    1.260004]  [<c0403e72>] ? ret_from_fork+0x6/0x1c
[    1.260012]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.260020]  [<c078b26a>] ? kernel_init+0x0/0x2b8
[    1.260028]  [<c0404b9b>] kernel_thread_helper+0x7/0x10
[    1.260036]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    1.260041] pciehp: pci_hp_register failed with error -17
[    1.260176] pciehp: Failed to register slot because of name collision. T=
ry 'pciehp_slot_with_bus' module option.
[    1.260318] pciehp: pciehp: slot initialization failed
[    1.260576] pciehp: PCI Express Hot Plug Controller Driver version: 0.4


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11917-1216939771-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiJBvkACgkQ7b8eESbyJLipMACghIF/NTQPluw+mu9P8XqGl1GH
S7QAn1hUC+ADRf09vt+12nAhfTvtiFb/
=P5mM
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11917-1216939771-0001-2--
