Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbXLNGbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbXLNGbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763437AbXLNGbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:31:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762511AbXLNGb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:31:27 -0500
Date: Thu, 13 Dec 2007 22:34:24 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071214063424.GB10100@suse.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de> <20071213.163505.14070110.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213.163505.14070110.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 04:35:05PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Thu, 13 Dec 2007 16:19:32 -0800
> 
> > On Thu, Dec 13, 2007 at 03:55:51PM -0800, venkatesh.pallipadi@intel.com wrote:
> > > Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
> > > 
> > > TBD: Do we need the ioctl interface to sysfs or get the type attribute
> > > through a different sysfs file. And then actually specify the attribute
> > > while doing pci_mmap_page_range ;-)
> > 
> > Woah!  No, no ioctls on sysfs files, sorry.  Not going to happen, do
> > this on a /dev file if you want to have ioctls...
> 
> Well since we told people to move over to sysfs for PCI
> accesses, and that's where mmap() is done via too,
> it should be no surprise that we run into problems when
> people want to set attributes for the mmap() as was done
> for the procfs case.
> 
> So you have two choices:
> 
> 1) Balk on the sysfs pci usage, and erase years of effort
>    of moving people over to sysfs.  Tell them to go back to
>    procfs so we can add the attribute setting via ioctl()
>    which is absolutely needed.

Ok, sorry, it wasn't blindingly obvious that this was for pci sysfs
devices that are mmaped, that makes a bit more sense.

But I'd like to see what ioctl is wanted here first.

thanks,

greg k-h
