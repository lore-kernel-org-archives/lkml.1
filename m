Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYIHRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYIHRLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYIHRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:11:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41287 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYIHRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:11:26 -0400
Date: Mon, 8 Sep 2008 10:08:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 4/4 v2] PCI: document the change
Message-Id: <20080908100800.a3f4c6b3.randy.dunlap@oracle.com>
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177EB70@pdsmsx414.ccr.corp.intel.com>
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB70@pdsmsx414.ccr.corp.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 19:21:06 +0800 Zhao, Yu wrote:

> Complete the hotplug ABI document, and add SR-IOV HOWTO.
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
> 
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   67 ++++++++++++
>  Documentation/DocBook/kernel-api.tmpl   |    3 +
>  Documentation/PCI/pci-iov-howto.txt     |  177 +++++++++++++++++++++++++++++++
>  3 files changed, 247 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/PCI/pci-iov-howto.txt

> diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
> new file mode 100644
> index 0000000..147e80f
> --- /dev/null
> +++ b/Documentation/PCI/pci-iov-howto.txt
> @@ -0,0 +1,177 @@
> +		PCI Express Single Root I/O Virtualization HOWTO
> +			Copyright (C) 2008 Intel Corporation
> +			    Yu Zhao <yu.zhao@intel.com>
> +
> +
> +1. Overview
> +
> +1.1 What is SR-IOV
> +

...

> +
> +1.2 What is ARI
> +

...

> +
> +
> +2. User Guide
> +
> +2.1 How can I manage SR-IOV
> +
> +If a device supports SR-IOV, then there should be some entires under

                                                          entries

> +/sys/bus/pci/slots/. The names of the entires are XXXX:BB:DD.F-iov-NNNN,

                                         entries

> +where the first part (XXXX:BB:DD.F) is the domain, bus, device and function
> +number of the device, and the third part (NNNN) is the index of a Virtual
> +Function. There are three files under the entry: power, param and address.
> +	- Writing 1 to the "power" will enable the Virtual Function,
> +	and 0 will disable the Virtual Function; Reading it will get
> +	status of the Virtual Function.
> +	- Reading the "address" will get the bus, device and function
> +	number of the Virtual Function.
> +	- The "param" is the device specific parameters which may be
> +	used by the Physical or Virtual Functions drivers.
> +
> +2.2 How can I use Virtual Functions
> +
> +Virtual Functions is treated as hot-plugged PCI devices in the kernel,

                     are

> +so they should be able to work in the same way as real PCI devices.
> +NOTE: Virtual Function device driver must be loaded to make it work.
> +
> +
> +3. Developer Guide
> +
> +3.1 SR-IOV APIs
> +

...

> +3.2 Usage example
> +

...

> +
> +#ifdef CONFIG_PM
> +/*
> + * If the device supports the power management, then the SR-IOV
> + * may be disabled before the adapter goes to sleep, because
> + * Virtual Functions may not work when the adapter is in the\

drop trailing '\'

> + * power-saving mode.
> + * The SR-IOV can be enabled again after the adapter wakes up.
> + */

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
