Return-Path: <linux-kernel-owner+w=401wt.eu-S934649AbXGRQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649AbXGRQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933615AbXGRQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:38:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14677 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbXGRQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:38:33 -0400
Date: Wed, 18 Jul 2007 09:41:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
Message-Id: <20070718094119.4a26ae03.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
	<Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 17:18:34 +0200 (CEST) Jan Engelhardt wrote:

> Hi,
> 
> 
> On Jul 16 2007 20:49, Stefan Richter wrote:
> >
> >It is an error to add visible Kconfig options without help text.  Among
> >them are the new "menuconfig" options.  Jan obviously never uses "make
> >oldconfig".
> 
> Untrue. Users of menuconfig/xconfig/gconfig who do not know what an
> item is supposed to do would not get any helptext either.
> It's just that I did not quite know what helptext to put there
> besides some trivial "enable this to see more fluffy options from
> this category". Feel free to add Blame-From: <srichter> :)
> But see below.
> 
> >Most of these options were added after 2.6.22:
> >
> >BLK_DEV
> >HID_SUPPORT
> >INSTRUMENTATION
> >MACINTOSH_DRIVERS
> >MISC_DEVICES
> >USB_SUPPORT
> >
> >Here are suggestions for help texts.  Please verify if they are correct
> >and check whether there are more new (menuconfig) options without help
> >texts.
> 
> Other config options without text include:
> 
> CRYPTO_HW       (b511431d85948823ec58639bd3137b910964be34)
> AUXDISPLAY      (f5920969fb9e29c9d60568864d0a56fe85e8f4b6)
> VIRTUALIZATION  (de062065a5293d8f434acb2d6ba5df87ad76bbd9)
> ATM_DRIVERS     (4151ce3159c18a990da7fd6f0fe36c73d1c40f87)
> NETDEV_1000     (f30486d57bceec2364aa696403d64429ada61b60)
> NETDEV_10000    (f30486d57bceec2364aa696403d64429ada61b60)
> 
> Thanks for the starting help texts. I have produced a cumulative patch
> with both yours and the extra ones listed above. Can we somehow sneak
> this directly in without split-to-maintainers? tis' just some help text.
> (Patch below)
> 
> >PS:
> >
> >I believe one possible *bug* of this menuconfig stuff is that if (1.)
> >user X disables menuconfig A in linux-2.6.x because nothing interesting
> >for him is in there, (2.) developer Y adds something very interesting in
> >menu A in linux-2.6.x+1, --> (3.) user X will miss this new option when
> >he runs "make oldconfig" when switching to linux-2.6.x+1 because
> >everything between 'if A'...'endif # A' will be invisible and disabled.
> 
> If I once said "I don't want no USB", I do not want to be prompted in a later
> version for USB_COFFEE_PAD. :)
> 
> 
> 	Jan
> ===
> >> add-help-texts-to-textless-menuconfig-objects.diff <<

Looks good to me except that help text should be indented by
2 more spaces according to CodingStyle.

> Add some help texts to recently-introduced kconfig items
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  arch/i386/Kconfig          |    5 +++++
>  drivers/atm/Kconfig        |    5 +++++
>  drivers/auxdisplay/Kconfig |    5 +++++
>  drivers/block/Kconfig      |    6 ++++++
>  drivers/crypto/Kconfig     |    5 +++++
>  drivers/hid/Kconfig        |    5 +++++
>  drivers/kvm/Kconfig        |    5 +++++
>  drivers/macintosh/Kconfig  |    6 ++++++
>  drivers/misc/Kconfig       |    5 +++++
>  drivers/net/Kconfig        |   15 +++++++++++++++
>  drivers/usb/Kconfig        |    3 +++
>  11 files changed, 65 insertions(+)
> 
> Index: linux-2.6.23/arch/i386/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/arch/i386/Kconfig
> +++ linux-2.6.23/arch/i386/Kconfig
> @@ -1216,6 +1216,11 @@ menuconfig INSTRUMENTATION
>  	bool "Instrumentation Support"
>  	depends on EXPERIMENTAL
>  	default y
> +	---help---
> +	Say Y here to get to see options related to performance measurement,
> +	debugging, and testing. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if INSTRUMENTATION
>  
> Index: linux-2.6.23/drivers/atm/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/atm/Kconfig
> +++ linux-2.6.23/drivers/atm/Kconfig
> @@ -6,6 +6,11 @@ menuconfig ATM_DRIVERS
>  	bool "ATM drivers"
>  	depends on NETDEVICES && ATM
>  	default y
> +	---help---
> +	Say Y here to get to see options for Asynchronous Transfer Mode
> +	device drivers. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if ATM_DRIVERS && NETDEVICES && ATM
>  
> Index: linux-2.6.23/drivers/auxdisplay/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/auxdisplay/Kconfig
> +++ linux-2.6.23/drivers/auxdisplay/Kconfig
> @@ -8,6 +8,11 @@
>  menuconfig AUXDISPLAY
>  	depends on PARPORT
>  	bool "Auxiliary Display support"
> +	---help---
> +	Say Y here to get to see options for auxiliary display drivers.
> +	This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if AUXDISPLAY && PARPORT
>  
> Index: linux-2.6.23/drivers/block/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/block/Kconfig
> +++ linux-2.6.23/drivers/block/Kconfig
> @@ -6,6 +6,12 @@ menuconfig BLK_DEV
>  	bool "Block devices"
>  	depends on BLOCK
>  	default y
> +	---help---
> +	Say Y here to get to see options for various different block device
> +	drivers. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled;
> +	only do this if you know what you are doing.
>  
>  if BLK_DEV
>  
> Index: linux-2.6.23/drivers/crypto/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/crypto/Kconfig
> +++ linux-2.6.23/drivers/crypto/Kconfig
> @@ -2,6 +2,11 @@
>  menuconfig CRYPTO_HW
>  	bool "Hardware crypto devices"
>  	default y
> +	---help---
> +	Say Y here to get to see options for hardware crypto devices and
> +	processors. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if CRYPTO_HW
>  
> Index: linux-2.6.23/drivers/hid/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/hid/Kconfig
> +++ linux-2.6.23/drivers/hid/Kconfig
> @@ -5,6 +5,11 @@ menuconfig HID_SUPPORT
>  	bool "HID Devices"
>  	depends on INPUT
>  	default y
> +	---help---
> +	Say Y here to get to see options for various computer-human interface
> +	device drivers. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if HID_SUPPORT
>  
> Index: linux-2.6.23/drivers/kvm/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/kvm/Kconfig
> +++ linux-2.6.23/drivers/kvm/Kconfig
> @@ -5,6 +5,11 @@ menuconfig VIRTUALIZATION
>  	bool "Virtualization"
>  	depends on X86
>  	default y
> +	---help---
> +	Say Y here to get to see options for virtualization guest drivers.
> +	This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if VIRTUALIZATION
>  
> Index: linux-2.6.23/drivers/macintosh/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/macintosh/Kconfig
> +++ linux-2.6.23/drivers/macintosh/Kconfig
> @@ -3,6 +3,12 @@ menuconfig MACINTOSH_DRIVERS
>  	bool "Macintosh device drivers"
>  	depends on PPC || MAC || X86
>  	default y if (PPC_PMAC || MAC)
> +	---help---
> +	Say Y here to get to see options for devices used with Macintosh
> +	computers, both PPC and Intel based. This option alone does not add
> +	any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if MACINTOSH_DRIVERS
>  
> Index: linux-2.6.23/drivers/misc/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/misc/Kconfig
> +++ linux-2.6.23/drivers/misc/Kconfig
> @@ -5,6 +5,11 @@
>  menuconfig MISC_DEVICES
>  	bool "Misc devices"
>  	default y
> +	---help---
> +	Say Y here to get to see options for device drivers from various
> +	different categories. This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if MISC_DEVICES
>  
> Index: linux-2.6.23/drivers/net/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/net/Kconfig
> +++ linux-2.6.23/drivers/net/Kconfig
> @@ -1923,6 +1923,16 @@ menuconfig NETDEV_1000
>  	bool "Ethernet (1000 Mbit)"
>  	depends on !UML
>  	default y
> +	---help---
> +	Ethernet (also called IEEE 802.3 or ISO 8802-2) is the most common
> +	type of Local Area Network (LAN) in universities and companies.
> +
> +	Say Y here to get to see options for Gigabit Ethernet drivers.
> +	This option alone does not add any kernel code.
> +	Note that drivers supporting both 100 and 1000 MBit may be listed
> +	under "Ethernet (10 or 100MBit)" instead.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if NETDEV_1000
>  
> @@ -2294,6 +2304,11 @@ menuconfig NETDEV_10000
>  	bool "Ethernet (10000 Mbit)"
>  	depends on !UML
>  	default y
> +	---help---
> +	Say Y here to get to see options for 10 Gigabit Ethernet drivers.
> +	This option alone does not add any kernel code.
> +
> +	If you say N, all options in this submenu will be skipped and disabled.
>  
>  if NETDEV_10000
>  
> Index: linux-2.6.23/drivers/usb/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/usb/Kconfig
> +++ linux-2.6.23/drivers/usb/Kconfig
> @@ -6,6 +6,9 @@ menuconfig USB_SUPPORT
>  	bool "USB support"
>  	depends on HAS_IOMEM
>  	default y
> +	---help---
> +	This option adds core support for Universal Serial Bus (USB).
> +	You will also need drivers from the following menu to make use of it.
>  
>  if USB_SUPPORT


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
