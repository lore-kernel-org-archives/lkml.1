Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIOMi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIOMi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZIOMiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:38:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZIOMiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:38:23 -0400
Date: Tue, 15 Sep 2009 18:07:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@linux.intel.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090915123752.GB5247@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911170010.34c80f2d@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Greg to the CC list]

On (Fri) Sep 11 2009 [17:00:10], Alan Cox wrote:
> > The interface presented to guest userspace is of a simple char
> > device, so it can be used like this:
> > 
> >     fd = open("/dev/vcon2", O_RDWR);
> >     ret = read(fd, buf, 100);
> >     ret = write(fd, string, strlen(string));
> > 
> > Each port is to be assigned a unique function, for example, the
> > first 4 ports may be reserved for libvirt usage, the next 4 for
> > generic streaming data and so on. This port-function mapping
> > isn't finalised yet.
> 
> Unless I am missing something this looks completely bonkers
> 
> Every time we have a table of numbers for functionality it ends in
> tears. We have to keep tables up to date and managed, we have to
> administer the magical number to name space.
> 
> Anyway - you don't seem to need a fixed number you can use dynamic
> allocation and udev.
> 
> There are at least two better ways to do this
> 
> - Using sysfs nodes so you have a proper heirarchy of names/functions
> - Using a simple file system which provides a heirarchy of nodes whose
>   enumeration and access is backed by calls to whatever happyvisor you
>   are using.
> 
> it then self enumerates, self populates, doesn't need anyone to keep
> updating magic tables of guest code and expands cleanly - yes ?

Hey Greg,

Can you tell me how this could work out -- each console port could have
a "role" string associated with it (obtainable from the invoking qemu
process in case of qemu/kvm). Something that I have in mind currently
is:

$ qemu-kvm ... -virtioconsole role=org/qemu/clipboard

and then the guest kernel sees the string, and puts the
"org/qemu/clipboard" in some file in sysfs. Guest userspace should then
be able to open and read/write to

/dev/virtio_console/org/qemu/clipboard

I guess that's an acceptable scheme to all.

I also don't know how this would work -- which sysfs attributes to
export and how would udev pick that up and create the device at the
specified location.

Any pointers appreciated.

Thanks,
		Amit
