Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYIZIHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYIZIHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYIZIGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:06:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37628 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIZIGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:06:48 -0400
Message-ID: <48DC9806.9040107@jp.fujitsu.com>
Date: Fri, 26 Sep 2008 17:06:30 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/14] PCI: let the core manage slot names
References: <20080923163753.12628.98683.stgit@bob.kio>
In-Reply-To: <20080923163753.12628.98683.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

> This series applies against linux-next. I've tested this by loading
> pci_slot and various hotplug drivers to ensure that the hotplug drivers
> can successfully override the pci_slot names.

  It seems that there are some bugs. Pciehp and shpchp modules can not
  be loaded when the debug option is specified. Segmentation fault occurs
  with stack dump.

  pciehp_probe() or shpchp_probe()
    -> init_slots()
     -> get_power_status()
      -> slot_name() : This is called when the debug option is specified.
       -> hotplug_slot_name()
        -> pci_slot_name(slot->pci_slot)
                         ~~~~~~~~~~~~~~
                        Not initialized yet.

-- 
Best regards,

Taku Izumi <izumi.taku@jp.fujitsu.com>

