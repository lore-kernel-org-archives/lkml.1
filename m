Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXKAUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXKAUK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXKAUKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:10:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53556 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXKAUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:10:48 -0400
Date: Thu, 1 Nov 2007 13:10:40 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: check boundary in count/setup_resource called by get_current_resources
Message-ID: <20071101201040.GA22247@us.ibm.com>
References: <200711010120.30410.yinghai.lu@sun.com> <20071101013239.992840bd.akpm@linux-foundation.org> <472A159A.6080106@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472A159A.6080106@sun.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 11:06:18AM -0700, Yinghai Lu wrote:
> Andrew Morton wrote:
> >On Thu, 01 Nov 2007 01:20:29 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> >
> >>[PATCH] x86: check boundary in count/setup_resource called by 
> >>get_current_resources
> >>
> >>need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
> >>info->bus->resource[info->res_num] = res will not beyond of bus resource 
> >>array
> >>when acpi resutrn too many resource entries.
> >>
> >
> >Isn't this a bit of a problem?  It sounds like PCI_BUS_NUM_RESOURCES is to
> >small for that system?  If so, some sort of dynamic allocation might be
> >needed.
> 
> sound reasonable...
> i have one local patch for amd64 that will get resources from pci conf. and 
> it will use all 8 slots for bus 0.
> and transparent bus under it only can copy 5 of them.

Yea, with the current fixed size pci_bus resource array
I believe you would need to increase PCI_BUS_NUM_RESOURCES
from 8 to 11 for the transparent bridge child bus to get
all 8 _CRS returned resources.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
