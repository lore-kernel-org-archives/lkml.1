Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbXJ1NTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbXJ1NTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 09:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXJ1NTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 09:19:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbXJ1NTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 09:19:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: USB_SUSPEND needs SUSPEND?
Date: Sun, 28 Oct 2007 14:35:30 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <4723D100.5050209@student.tuwien.ac.at>
In-Reply-To: <4723D100.5050209@student.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710281435.31690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 02:00, Oliver Martin wrote:
> Hello,
> 
> it seems that there is some dependency missing for CONFIG_USB_SUSPEND.
> When I compile a kernel without CONFIG_SUSPEND, USB suspend doesn't work
> (or at least doesn't expose its interface to userspace).
> /sys/bus/usb/devices/.../power doesn't exist, but it is there when I
> enable CONFIG_SUSPEND. So should CONFIG_USB_SUSPEND depend on
> CONFIG_SUSPEND (or something selected by CONFIG_SUSPEND)?
> 
> diff between the two configs follows, full config and dmesg for both
> kernels is available at http://stud4.tuwien.ac.at/~e0626486/usb_suspend/
> (though the dmesg diff doesn't seem to be all that interesting).

Some CCs added.

> --- /boot/config-2.6.23.1-nosuspend
> +++ /boot/config-2.6.23.1-suspend
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.23.1
> -# Sat Oct 27 23:59:11 2007
> +# Sat Oct 27 22:45:27 2007
>  #
>  CONFIG_X86_32=y
>  CONFIG_GENERIC_TIME=y
> @@ -30,7 +30,7 @@
>  CONFIG_EXPERIMENTAL=y
>  CONFIG_BROKEN_ON_SMP=y
>  CONFIG_INIT_ENV_ARG_LIMIT=32
> -CONFIG_LOCALVERSION="-nosuspend"
> +CONFIG_LOCALVERSION="-suspend"
>  # CONFIG_LOCALVERSION_AUTO is not set
>  CONFIG_SWAP=y
>  CONFIG_SYSVIPC=y
> @@ -229,11 +229,13 @@
>  CONFIG_PM=y
>  CONFIG_PM_LEGACY=y
>  # CONFIG_PM_DEBUG is not set
> +CONFIG_PM_SLEEP=y
>  CONFIG_SUSPEND_UP_POSSIBLE=y
> -# CONFIG_SUSPEND is not set
> +CONFIG_SUSPEND=y
>  CONFIG_HIBERNATION_UP_POSSIBLE=y
>  # CONFIG_HIBERNATION is not set
>  CONFIG_ACPI=y
> +CONFIG_ACPI_SLEEP=y
>  CONFIG_ACPI_PROCFS=y
>  CONFIG_ACPI_PROC_EVENT=y
>  CONFIG_ACPI_AC=m
> @@ -255,6 +257,7 @@
>  CONFIG_X86_PM_TIMER=y
>  CONFIG_ACPI_CONTAINER=m
>  CONFIG_ACPI_SBS=m
> +# CONFIG_APM is not set
> 
>  #
>  # CPU Frequency scaling
> 
> 
