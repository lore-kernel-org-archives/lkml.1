Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbXJQKSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbXJQKSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 06:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXJQKRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 06:17:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXJQKRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 06:17:42 -0400
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: David Miller <davem@davemloft.net>, jens.axboe@oracle.com, rjw@sisk.pl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       htejun@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071016232350.GB24827@kroah.com>
References: <20071016204238.GA1093@kroah.com>
	 <20071016205053.GI9942@kernel.dk> <20071016213730.GB21815@kroah.com>
	 <20071016.153248.95506316.davem@davemloft.net>
	 <20071016232350.GB24827@kroah.com>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 12:16:54 +0200
Message-Id: <1192616214.4300.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18IJWMoMQiNxTISjTkAJvJOYzTyKehFuduFFBB
 +2eSTJaT1WYsTS4aZsScQuPrQNpdH1A0jZZ2htT7RGxvVIh8y5
 hohdhVdscWIWzMcM/HKYIp9pbUKzq6H
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 16:23 -0700, Greg KH wrote:
> On Tue, Oct 16, 2007 at 03:32:48PM -0700, David Miller wrote:
> > From: Greg KH <greg@kroah.com>
> > Date: Tue, 16 Oct 2007 14:37:30 -0700
> > 
> > > Kay, are we doing something wrong in userspace when renaming wireless
> > > devices such that we can overlap names?

Not udev, but SUSE 10.2's network renaming. It uses udev and calls
ifrename in the same code path. 10.3 uses the unified version from the
udev tree.

> > It does it for all network devices, I see this ugly message on every
> > single system I have from Fedora foo to RHEL foo to ubuntu foo to
> > debian foo.
> >
> > udev simply applies the MAC address to device name rules blindly, it
> > doesn't check if the device already has the desired name already

There is a check for the same name in udev for long.

> Ugh :(
> 
> > It's been like this forever, and since userland has been doing it for
> > so long, you can't warn on this there is too much established
> > practice.  Expecting people to install "fixed" udev is not an
> > acceptable answer, the warning is a regression and therefore you'll
> > have to remove the kernel warning for this case and live with this
> > issue essentially forever.

We should probably just add the check to kobject_rename() and print a
simple warning and then do nothing. Or just do the check in the network
ioctl, if we really don't want to see this.

> Nope, I guess we will have to take out the check (or put it under the
> kobject debugging flag), unless Kay has any other ideas...

We should really keep it, it already exposed a lot of serious bugs in
the kernel and users, we never spotted before.

Kay

