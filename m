Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZIKQjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZIKQjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZIKQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIKQjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:39:07 -0400
Date: Fri, 11 Sep 2009 22:08:06 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@linux.intel.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090911163806.GB25535@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911170010.34c80f2d@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Right; there was some discussion about this. A few alternatives were
suggested like

- udev scripts to create symlinks from ports to function, like:

  /dev/vcon3 -> /dev/virtio-console/clipboard

- Some fqdn-like hierarchy, like

  /dev/virtio-console/com/redhat/clipboard

  which again can be created by udev scripts

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

Agreed. I'd prefer udev scripts doing it vs doing it in the code as it
keeps everything simple and the policy isn't laid out in the kernel
module. Is that fine?

		Amit
