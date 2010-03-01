Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0CARhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:37:40 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:34135 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751359Ab0CARhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:37:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XJaJexw1b/Ag2yFoC0trPnsOqcYqrRonI9I6vDPj9jOAwpgQD8iVJK7dxv2CNCIRRXwr0dADooSRAWy2f58OAO52xpDb3dYKisYVX5mYzm3tNM8N5BMm/1YX4a3yu7q8;
Date: Mon, 1 Mar 2010 09:38:31 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / PM / Runtime: Make runtime PM of PCI devices
 inactive by default
Message-ID: <20100301093831.18928f85@jbarnes-piketon>
In-Reply-To: <201002272137.37349.rjw@sisk.pl>
References: <201002272137.37349.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 21:37:37 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the run-time power management of PCI devices be inactive by
> default by calling pm_runtime_forbid() for each PCI device during its
> initialization.  This setting may be overriden by the user space with
> the help of the /sys/devices/.../power/control interface.
> 
> That's necessary to avoid breakage on systems where ACPI-based
> wake-up is known to fail for some devices.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1540,8 +1540,10 @@ void pci_pm_init(struct pci_dev *dev)
>  	int pm;
>  	u16 pmc;
>  
> +	pm_runtime_forbid(&dev->dev);
>  	device_enable_async_suspend(&dev->dev);
>  	dev->wakeup_prepared = false;
> +
>  	dev->pm_cap = 0;
>  
>  	/* find PCI PM capability in list */
> 

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
