Return-Path: <linux-kernel-owner+w=401wt.eu-S935220AbXLNAfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935220AbXLNAfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932552AbXLNAfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:35:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38407
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932289AbXLNAfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:35:06 -0500
Date: Thu, 13 Dec 2007 16:35:05 -0800 (PST)
Message-Id: <20071213.163505.14070110.davem@davemloft.net>
To: gregkh@suse.de
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071214001932.GA10389@suse.de>
References: <20071213235543.568682000@intel.com>
	<20071213235712.813201000@intel.com>
	<20071214001932.GA10389@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 13 Dec 2007 16:19:32 -0800

> On Thu, Dec 13, 2007 at 03:55:51PM -0800, venkatesh.pallipadi@intel.com wrote:
> > Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
> > 
> > TBD: Do we need the ioctl interface to sysfs or get the type attribute
> > through a different sysfs file. And then actually specify the attribute
> > while doing pci_mmap_page_range ;-)
> 
> Woah!  No, no ioctls on sysfs files, sorry.  Not going to happen, do
> this on a /dev file if you want to have ioctls...

Well since we told people to move over to sysfs for PCI
accesses, and that's where mmap() is done via too,
it should be no surprise that we run into problems when
people want to set attributes for the mmap() as was done
for the procfs case.

So you have two choices:

1) Balk on the sysfs pci usage, and erase years of effort
   of moving people over to sysfs.  Tell them to go back to
   procfs so we can add the attribute setting via ioctl()
   which is absolutely needed.

2) Relax your restrictions a little bit and allow ioctl()'s
   for limited cases, like this one.

Otherwise, propase a way to specify PCI device mmap attributes
which works within your whole-universe sysfs theory of everything
:-)
