Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbXLMTIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbXLMTIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXLMTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:08:07 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:11832 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbXLMTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:08:05 -0500
Date: Thu, 13 Dec 2007 12:08:02 -0700
From: Alex Chiang <achiang@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: akpm@linux-foundation.org, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Expose _SUN in /proc/acpi/processor/<...>/info
Message-ID: <20071213190801.GA7747@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Len Brown <lenb@kernel.org>, akpm@linux-foundation.org,
	linux-acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20071019193844.GL8122@ldl.fc.hp.com> <20071030235057.GD3127@ldl.fc.hp.com> <200711191254.33682.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711191254.33682.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

* Len Brown <lenb@kernel.org>:
> On Tuesday 30 October 2007 19:50, Alex Chiang wrote:
> > 
> > I'm looking for comments on the following patch that exposes _SUN
> > on processor objects in /proc/acpi/processor/<...>/info. 
> > 
> > This didn't get many comments on the linux-acpi list, so I'm
> > sending to a wider distribution.
> > 
> > I notice that acpiphp exposes _SUN for (hotpluggable) PCI slots
> > in /sys/bus/pci/slots/N/, where N is the value of _SUN. I'm not
> > so sure we want to go *exactly* in the same direction for CPUs,
> > because:
> > 
> >   - x86 systems might not implement _SUN for processors
> >   - ia64 systems that implement ACPI 2.x do not have unique
> >     values for _SUN across the entire system
> > 
> > Nonetheless, even non-unique values of _SUN are still helpful for
> > userspace to figure out which physical socket a CPU might be in,
> > especially when combined with information from /proc/cpuinfo.
> > 
> > Thoughts?
> 
> We've not allowed new features in /proc/acpi
> since we started removing /proc/acpi.
> ie. we don't want to update the API, we want to delete it.
 
Ok.

> If this is a useful thing for user-space to know, then you need
> to figure out a generic way to present it -- likely under
> /sys/devices/system/cpu/
 
There are lots of ways to go with this, and I'd like to get an
idea of what you think makes most sense before going off and
spending tons of time here.

I see possible choices as:

  1) create something like:
  
	/sys/devices/system/cpu/cpuN/topology/socket_id

     And leave it up to the arch to figure if/how they want to
     implement it. On ia64 systems, we can get this information
     from the _SUN method.

  2) create something like:

  	/sys/devices/system/cpu/cpuN/acpi/

     And port over the stuff from /proc/acpi, adding in a new
     field for _SUN.

Thoughts?

Thanks.

/ac

