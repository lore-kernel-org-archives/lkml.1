Return-Path: <linux-kernel-owner+w=401wt.eu-S1946064AbXDEIBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946064AbXDEIBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946059AbXDEIBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:01:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:43558 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946064AbXDEIBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,375,1170662400"; 
   d="scan'208"; a="225113043:sNHT22931153"
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
From: Zhang Rui <rui.zhang@intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200704031741.42273.david-b@pacbell.net>
References: <200704031741.42273.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 15:59:55 +0800
Message-Id: <1175759995.23121.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 08:41 +0800, David Brownell wrote:
> This updates /proc/acpi/wakeup to be more informative, primarily by
> showing
> the sysfs node associated with each wakeup-enabled device.  Example:
> 
>         Device  S-state   Status   Sysfs node
>         PCI0      S4     disabled  no-bus:pci0000:00
>         PS2M      S4     disabled  pnp:00:05
>         PS2K      S4     disabled  pnp:00:06
>         UAR1      S4     disabled  pnp:00:08
>         USB1      S3     disabled  pci:0000:00:03.0
>         USB2      S3     disabled  pci:0000:00:03.1
>         USB3      S3     disabled 
>         USB4      S3     disabled  pci:0000:00:03.3
>         S139      S4     disabled 
>         LAN       S4     disabled  pci:0000:00:04.0
>         MDM       S4     disabled 
>         AUD       S4     disabled  pci:0000:00:02.7
>         SLPB      S4    *enabled  
> 
> Eventually this file should be removed, but until then it's almost the
> only
> way we have to tell how the relevant ACPI tables are broken (and
> cope).  In
> that example, two devices don't actually exist (USB3, S139), one can't
> issue
> wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and
> AUD are
> the same PCI device, but it's the _modem_ that does wake-on-ring). 
> 
Well, ACPI can't find the sysfs node for all the wakeup-enabled devices.
In fact, only pci and pnp devices can be found now.
ACPI needs the ability to distinguish all the physical devices, i.e. map
ACPI device to physical device nodes in sysfs, which I mentioned before.

Thanks,
Rui
