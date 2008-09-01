Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYIAPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYIAPbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYIAPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:31:22 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:15155 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYIAPbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:31:21 -0400
Date: Mon, 1 Sep 2008 09:30:20 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 3/4 v2] PCI: support SR-IOV capability
Message-ID: <20080901153020.GD16796@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> Support SR-IOV capability. By default, this feature is not enabled and the SR-IOV device behaves as traditional PCI device. After it's enabled, each Virtual Function's PCI configuration space can be accessed using its own Bus, Device and Function Number (Routing ID). Each Virtual Function also has PCI Memory Space, which is used to map its own register set.
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
> 
> ---
>  drivers/pci/Kconfig      |   10 +
>  drivers/pci/Makefile     |    2 +
>  drivers/pci/iov.c        |  555 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.c        |   14 +-
>  drivers/pci/pci.h        |   44 ++++
>  drivers/pci/probe.c      |    5 +
>  include/linux/pci.h      |   28 +++
>  include/linux/pci_regs.h |   20 ++
>  8 files changed, 677 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/pci/iov.c
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index f43cc46..0a1fe01 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -57,3 +57,13 @@ config PCI_ARI
>  	default n
>  	help
>  	  This enables PCI Alternative Routing-ID Interpretation.
> +
> +config PCI_IOV
> +	bool "PCI SR-IOV support"
> +	depends on PCI && HOTPLUG
> +	select PCI_MSI
> +	select PCI_ARI
> +	select HOTPLUG_PCI
> +	default n
> +	help
> +	  This allows device drivers to enable Single Root I/O Virtualization.

I'd like to see this Kconfig help text enhanced too. Telling a
user that PCI_IOV enables Single Root I/O Virtualization isn't
that helpful, but explaining what SR-IOV actually gets you _is_
helpful.

	This option allows device drivers to enable Single Root I/O
	Virtualization.  Each Virtual Function's PCI configuration
	space can be accessed using its own Bus, Device and Function
	Number (Routing ID). Each Virtual Function also has PCI Memory
	Space, which is used to map its own register set.

Thanks.

/ac

