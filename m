Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYIJIAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYIJIAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYIJIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:00:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:41249 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYIJIAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:00:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="334776243"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 3/4 v2] PCI: support SR-IOV capability
Date: Wed, 10 Sep 2008 15:59:35 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110181CB1A@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080901164104.GG16796@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4 v2] PCI: support SR-IOV capability
Thread-Index: AckMUYt2tIuCy1AsQbuoynIuQIikzAGyRzjg
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com> <20080901164104.GG16796@ldl.fc.hp.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Alex Chiang" <achiang@hp.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 10 Sep 2008 07:59:38.0437 (UTC) FILETIME=[2C427F50:01C9131B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 02, 2008 12:41 AM, Alex Chiang wrote:
>* Zhao, Yu <yu.zhao@intel.com>:
>> Support SR-IOV capability. By default, this feature is not enabled and the
>SR-IOV device behaves as traditional PCI device. After it's enabled, each
>Virtual Function's PCI configuration space can be accessed using its own Bus,
>Device and Function Number (Routing ID). Each Virtual Function also has PCI
>Memory Space, which is used to map its own register set.
>>
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
>>
>> ---
>>  drivers/pci/Kconfig      |   10 +
>>  drivers/pci/Makefile     |    2 +
>>  drivers/pci/iov.c        |  555
>++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/pci/pci.c        |   14 +-
>>  drivers/pci/pci.h        |   44 ++++
>>  drivers/pci/probe.c      |    5 +
>>  include/linux/pci.h      |   28 +++
>>  include/linux/pci_regs.h |   20 ++
>>  8 files changed, 677 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/pci/iov.c
>>
>
>So, what happens if another hotplug driver is already loaded?
>
>I don't know the SR-IOV spec well enough to know if you are
>allowed to have SR-IOV + some other form of hotplug, like ACPI or
>native PCIe.
>
>Today, pci_hp_register will return -EBUSY.
>
>If SR-IOV really doesn't have anything to do with hotplug, then
>it may be a candidate for directly calling pci_create_slot(). In
>that case, 'param' should not be a property of a hotplug slot,
>but of a generic PCI slot.

That's correct, SR-IOV really doesn't have anything to do with hotplug. I was just reusing hotplug sysfs as the control interface. Will remove this in next work, and create SR-IOV own sysfs entries under /sys/bus/pci/devices/.../iov/...

Thanks.

>
>Thanks.
>
>/ac

