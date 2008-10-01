Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYJAVFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYJAVFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYJAVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:04:54 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13096 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYJAVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:04:53 -0400
Date: Wed, 1 Oct 2008 15:04:51 -0600
From: Alex Chiang <achiang@hp.com>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/14] PCI: let the core manage slot names
Message-ID: <20081001210451.GA15531@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, matthew@wil.cx,
	kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080923163753.12628.98683.stgit@bob.kio> <48DC9806.9040107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC9806.9040107@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taku-san,

* Taku Izumi <izumi.taku@jp.fujitsu.com>:
>> This series applies against linux-next. I've tested this by loading
>> pci_slot and various hotplug drivers to ensure that the hotplug drivers
>> can successfully override the pci_slot names.
>
>  It seems that there are some bugs. Pciehp and shpchp modules can not
>  be loaded when the debug option is specified. Segmentation fault occurs
>  with stack dump.
>
>  pciehp_probe() or shpchp_probe()
>    -> init_slots()
>     -> get_power_status()
>      -> slot_name() : This is called when the debug option is specified.
>       -> hotplug_slot_name()
>        -> pci_slot_name(slot->pci_slot)
>                         ~~~~~~~~~~~~~~
>                        Not initialized yet.

Thank you for pointing this out. I've fixed this (and the other
drivers) by make sure that the slot names are initialized before
we attempt to use them.

Trying to fix rpaphp was too much work for very little gain, so I
deleted that patch from my patch series. But the changes to the
hotplug core still make sense, so it's ok to have just one
oddball left.

I'll wait until Kenji-san sends out his final review comments
before sending out v4.

Thanks.

/ac

