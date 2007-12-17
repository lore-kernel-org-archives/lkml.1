Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbXLQMlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbXLQMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXLQMll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:41:41 -0500
Received: from colin.muc.de ([193.149.48.1]:1273 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXLQMll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:41:41 -0500
Date: 17 Dec 2007 13:41:37 +0100
Date: Mon, 17 Dec 2007 13:41:37 +0100
From: Andi Kleen <ak@muc.de>
To: Paul Mackerras <paulus@samba.org>
Cc: Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       venkatesh.pallipadi@intel.com, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071217124137.GA18648@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de> <20071213.163505.14070110.davem@davemloft.net> <20071214063424.GB10100@suse.de> <18277.40798.828760.919571@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18277.40798.828760.919571@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 08:57:50AM +1100, Paul Mackerras wrote:
> Greg KH writes:
> 
> > Ok, sorry, it wasn't blindingly obvious that this was for pci sysfs
> > devices that are mmaped, that makes a bit more sense.
> > 
> > But I'd like to see what ioctl is wanted here first.
> 
> I believe the ioctl would be to set whether the mapping goes to I/O or
> memory space, 

x86 cannot really access IO space through mmap so no that wasn't planned

The main planned use was to get the translated bus address (after IOMMU)
for a mapping and to set the caching modes.

> So the alternative to the ioctl would be to have multiple files in
> sysfs, one per combination of modes -- i.e., 4 files, or 3 if we
> exclude the "I/O with write combining" mode, which would be
> reasonable.

At least for the IOMMU translation case that wouldn't work.

-Andi
