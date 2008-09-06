Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYIFVux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYIFVux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFVuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:50:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:28031 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYIFVun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:50:43 -0400
Date: Sat, 6 Sep 2008 15:50:41 -0600
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: hotplug create_slot hang
Message-ID: <20080906215041.GD27298@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yhlu.kernel@gmail.com>:
> calling  pci_hotplug_init+0x0/0x1d
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> initcall pci_hotplug_init+0x0/0x1d returned 0 after 11 msecs
> 
> calling  acpiphp_init+0x0/0x5f
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> decode_hpp: Could not get hotplug parameters. Use defaults
> pci_create_slot: created pci_slot on 0000:07:00
> acpiphp: Slot [1] registered
> decode_hpp: Could not get hotplug parameters. Use defaults
> pci_create_slot: created pci_slot on 0000:0d:00
> acpiphp: Slot [2] registered
> initcall acpiphp_init+0x0/0x5f returned 0 after 105 msecs

Is this the hang?

> calling  pcied_init+0x0/0x7b
> pciehp: HPC vendor_id 8086 device_id 340a ss_vid 0 ss_did 0
> pci_create_slot: inc refcount to 2 on 0000:07:00
> pci_destroy_slot: dec refcount to 1 on 0000:07:00
> pciehp: pci_hp_register failed with error -16
> pciehp: pciehp: slot already registered by another hotplug driver

This failure is by design -- we only allow one hotplug driver to
claim a slot now, and it's "first one loaded wins".

Unless you're talking about something else?

Thanks.

/ac

