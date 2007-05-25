Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXEYXmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXEYXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXEYXmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:42:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:64421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXEYXmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:42:01 -0400
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       Cornelia Huck <cornelia.huck@de.ibm.com>
In-Reply-To: <20070525231257.GA9616@suse.de>
References: <20070525163621.GE11166@waste.org>
	 <20070525164842.GA6220@suse.de>
	 <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
	 <20070525175319.GK11115@waste.org> <20070525210152.GL11115@waste.org>
	 <20070525230109.GN11115@waste.org>  <20070525231257.GA9616@suse.de>
Content-Type: text/plain
Date: Sat, 26 May 2007 01:40:50 +0200
Message-Id: <1180136450.4226.45.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/5qpMPf2HiY0AuZYtnRSGdIb/w76F2Bc7xuRt
 i9TLpLxTbP2kVhYHK4U7u9sz7lp/GA7t3onO21FCWR6dqNRxe1
 CPp6Ror6O0/+t8cOAdjBu8EBIoAeRTe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 16:12 -0700, Greg KH wrote:
> On Fri, May 25, 2007 at 06:01:09PM -0500, Matt Mackall wrote:
> > Bisect sequence went 56+ 84+ 98+ 105- 102- 100+ 101+. Looks like 102's
> > to blame:
> > 
> > driver-core-check-return-code-of-sysfs_create_link.patch 
> > 
> > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > 
> > Check for return value of sysfs_create_link() in device_add() and
> > device_rename().  Add helper functions device_add_class_symlinks() and
> > device_remove_class_symlinks() to make the code easier to read.
> 
> {sigh}
> 
> This wouldn't be the first time this patch has broken things :(
> 
> Andrew, can you drop this from your tree?
> 
> Cornelia, can you rework this to not break things?

Before we continue that road, we should define the expected behavior for
the "cleanup" in error paths. Implementing that transaction-like model,
to rewind a the complete device-creation when something like a symlink
can't be created, may not always be the right thing to do.

I think in most cases, we just want to write something like that to the
error logs and continue, instead of letting a whole subsystem fail, or
in the worst case, prevent the box from booting up.

Thanks,
Kay

