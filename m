Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYA3FYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYA3FYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYA3FYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:24:43 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41834 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYA3FYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:24:42 -0500
Date: Tue, 29 Jan 2008 21:23:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, auke-jan.h.kok@intel.com,
       jeff@garzik.org, davem@davemloft.net, akpm <akpm@linux-foundation.org>
Subject: Re: Mostly revert
 "e1000/e1000e: Move PCI-Express device IDs over to e1000e"
Message-Id: <20080129212314.91b9bb5b.randy.dunlap@oracle.com>
In-Reply-To: <200801292359.m0TNxb75011826@hera.kernel.org>
References: <200801292359.m0TNxb75011826@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Tue, 29 Jan 2008 23:59:37 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5b10ca19ea4859d3884d10a3eb8495de92089792
> Commit:     5b10ca19ea4859d3884d10a3eb8495de92089792
> Parent:     9e97198dbf318be7958b57900d05b37c7e09ad7c
> Author:     Linus Torvalds <torvalds@linux-foundation.org>
> AuthorDate: Wed Jan 30 09:54:54 2008 +1100
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Jan 30 09:54:54 2008 +1100
> 
>     Mostly revert "e1000/e1000e: Move PCI-Express device IDs over to e1000e"
>     
>     The new e1000e driver is apparently not yet suitable for general use, so
>     mark it experimental, and re-instate all the PCI-Express device IDs in
>     the old and stable e1000 driver so that people (namely me) can continue
>     to use a driver that actually works.
>     
>     Auke & co have been appraised of the situation.
>     
>     Cc: Auke Kok <auke-jan.h.kok@intel.com>
>     Cc: Jeff Garzik <jeff@garzik.org>
>     Cc: David Miller <davem@davemloft.net>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Andrew was concerned about this when the driver was in -mm.
He asked for a patch that would set E1000E to same value as E1000
and I supplied that.  Auke acked it IIRC.  Other people vetoed it.  :(


> ---
>  drivers/net/Kconfig            |    2 +-
>  drivers/net/e1000/e1000_main.c |   27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index af40ff4..5a2d1dd 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -1992,7 +1992,7 @@ config E1000_DISABLE_PACKET_SPLIT
>  
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
> -	depends on PCI
> +	depends on PCI && EXPERIMENTAL
>  	---help---
>  	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
>  	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index 7f5b2ae..3111af6 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -73,6 +73,14 @@ static struct pci_device_id e1000_pci_tbl[] = {
>  	INTEL_E1000_ETHERNET_DEVICE(0x1026),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1027),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1028),
> +	INTEL_E1000_ETHERNET_DEVICE(0x1049),
> +	INTEL_E1000_ETHERNET_DEVICE(0x104A),
> +	INTEL_E1000_ETHERNET_DEVICE(0x104B),
> +	INTEL_E1000_ETHERNET_DEVICE(0x104C),
> +	INTEL_E1000_ETHERNET_DEVICE(0x104D),
> +	INTEL_E1000_ETHERNET_DEVICE(0x105E),
> +	INTEL_E1000_ETHERNET_DEVICE(0x105F),
> +	INTEL_E1000_ETHERNET_DEVICE(0x1060),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1075),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1076),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1077),
> @@ -81,9 +89,28 @@ static struct pci_device_id e1000_pci_tbl[] = {
>  	INTEL_E1000_ETHERNET_DEVICE(0x107A),
>  	INTEL_E1000_ETHERNET_DEVICE(0x107B),
>  	INTEL_E1000_ETHERNET_DEVICE(0x107C),
> +	INTEL_E1000_ETHERNET_DEVICE(0x107D),
> +	INTEL_E1000_ETHERNET_DEVICE(0x107E),
> +	INTEL_E1000_ETHERNET_DEVICE(0x107F),
>  	INTEL_E1000_ETHERNET_DEVICE(0x108A),
> +	INTEL_E1000_ETHERNET_DEVICE(0x108B),
> +	INTEL_E1000_ETHERNET_DEVICE(0x108C),
> +	INTEL_E1000_ETHERNET_DEVICE(0x1096),
> +	INTEL_E1000_ETHERNET_DEVICE(0x1098),
>  	INTEL_E1000_ETHERNET_DEVICE(0x1099),
> +	INTEL_E1000_ETHERNET_DEVICE(0x109A),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10A4),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10A5),
>  	INTEL_E1000_ETHERNET_DEVICE(0x10B5),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10B9),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10BA),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10BB),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10BC),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10C4),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10C5),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10D5),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10D9),
> +	INTEL_E1000_ETHERNET_DEVICE(0x10DA),
>  	/* required last entry */
>  	{0,}
>  };

---
~Randy
