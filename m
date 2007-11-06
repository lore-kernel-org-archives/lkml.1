Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXKFTrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXKFTrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbXKFTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:47:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:34464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXKFTrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:47:09 -0500
Date: Tue, 6 Nov 2007 11:39:28 -0800
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded -
	build failure - rpadlpar_sysfs
Message-ID: <20071106193928.GA30277@suse.de>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <4730896A.9060701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730896A.9060701@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 09:04:02PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The build fails with following error
>  
>   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj.parent')
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj')
> drivers/pci/hotplug/rpadlpar_sysfs.c:134: error: unknown field `ktype' specified in initializer
> drivers/pci/hotplug/rpadlpar_sysfs.c:134: warning: initialization from incompatible pointer type
> make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[2]: *** [drivers/pci/hotplug] Error 2
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2
> 
> The patch, gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
> is causing the build failure.

Actually, in looking at that file some more, the whole way that file
creates sysfs files and uses them is so messed up it's not funny (get
the return value of writing to a file by reading from it?  WTF?)

I'll go clean up all this crap now that we can do simple kobject
attributes easier...

thanks,

greg k-h
