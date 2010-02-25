Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab0BYRgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:36:20 -0500
Received: from kroah.org ([198.145.64.141]:39226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab0BYRgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:36:19 -0500
Date: Thu, 25 Feb 2010 09:36:11 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100225173611.GA14124@kroah.com>
References: <20100225164436.GA3310@kroah.com>
 <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 05:30:29PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > So, is there a way to "know" ahead of time if we are in a HV guest
> > environment?
> 
> Here is some info from dmesg, which shows "VRTUAL MICROSFT".
> ACPI: RSDT (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0000
> ACPI: FADT (v002 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0200
> ACPI: WAET (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0b00
> ACPI: SLIC (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0b40
> ACPI: OEM0 (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0d40
> ACPI: SRAT (v002 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0600
> ACPI: MADT (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001fff0300
> ACPI: OEMB (v001 VRTUAL MICROSFT 0x03000919 MSFT 0x00000097) @ 0x000000001ffff240
> ACPI: DSDT (v001 MSFTVM MSFTVM02 0x00000002 INTL 0x02002026) @ 0x0000000000000000

That's a good start, so which device can we key off of here?

What does the following command output in a HV virtual system:
	grep . /sys/bus/acpi/devices/*/modalias

That might give us something that we can use.

How about DMI data?  Does the Host export any info there?  Is there
anything in the /sys/class/dmi/id/ directory?  If so, can you send the
output of:
	cat /sys/class/dmi/id/modalias

And you are sure no PCI devices are present to key off of that are never
going to show up in a "physical" machine?

What do you recommend doing here?

thanks,

greg k-h
