Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXDNNS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXDNNS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030403AbXDNNS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:18:26 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:61122 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030400AbXDNNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:18:25 -0400
Message-ID: <4620D325.8050903@student.ltu.se>
Date: Sat, 14 Apr 2007 15:12:05 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI: the overdue removal of pci_module_init()
References: <20070406101948.GE29169@stusta.de>
In-Reply-To: <20070406101948.GE29169@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Unless we finally completely remove it, people will always add new users.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>   
If this is really it, then ACK!
> ---
>  Documentation/feature-removal-schedule.txt |    7 -------
>  Documentation/pci.txt                      |    2 --
>  include/linux/pci.h                        |    6 ------
>  3 files changed, 15 deletions(-)
>
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -105,13 +105,6 @@ Who:   Adrian Bunk <bunk@stusta.de>
>  
>  ---------------------------
>  
> -What:	pci_module_init(driver)
> -When:	January 2007
> -Why:	Is replaced by pci_register_driver(pci_driver).
> -Who:	Richard Knutsson <ricknu-0@student.ltu.se> and Greg Kroah-Hartman <gregkh@suse.de>
> -
> ----------------------------
> -
>  What:	Usage of invalid timevals in setitimer
>  When:	March 2007
>  Why:	POSIX requires to validate timevals in the setitimer call. This
> --- a/Documentation/pci.txt
> +++ b/Documentation/pci.txt
> @@ -545,8 +545,6 @@ pci_find_slot()			Find pci_dev correspon
>  pci_set_power_state()		Set PCI Power Management state (0=D0 ... 3=D3)
>  pci_find_capability()		Find specified capability in device's capability
>  				list.
> -pci_module_init()		Inline helper function for ensuring correct
> -				pci_driver initialization and error handling.
>  pci_resource_start()		Returns bus start address for a given PCI region
>  pci_resource_end()		Returns bus end address for a given PCI region
>  pci_resource_len()		Returns the byte length of a PCI region
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -405,12 +405,6 @@ struct pci_driver {
>  	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
>  	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>  
> -/*
> - * pci_module_init is obsolete, this stays here till we fix up all usages of it
> - * in the tree.
> - */
> -#define pci_module_init	pci_register_driver
> -
>  /**
>   * PCI_VDEVICE - macro used to describe a specific pci device in short form
>   * @vend: the vendor name
>
>
> Patches currently in gregkh-2.6 which might be from bunk@stusta.de are
>
> bad/sysfs-crash-debugging.patch
> driver/the-overdue-removal-of-the-mount-umount-uevents.patch
> pci/pci-fix-multiple-definition-of-queue_pushbutton_work.patch
> pci/pci-remove-the-broken-pci_multithread_probe-option.patch
> pci/pci-define-pci_request-release_regions-for-config_pci-n.patch
> pci/pci-the-overdue-removal-of-pci_module_init.patch
> usb/usb-gtco.c-fix-a-use-before-check.patch
> usb/usb-iowarrior.c-fix-null-dereference.patch
>   

