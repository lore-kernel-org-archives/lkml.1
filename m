Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZIVCoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZIVCoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZIVCoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:44:10 -0400
Received: from ozlabs.org ([203.10.76.45]:33193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZIVCoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:44:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 22 Sep 2009 12:14:04 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Amit Shah <amit.shah@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com>
In-Reply-To: <20090911170010.34c80f2d@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221214.04340.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009 01:30:10 am Alan Cox wrote:
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

The number comes from the ABI; we need some identifier for the different
ports.  Amit started using names, and I said "just use numbers"; they have
to be documented and agreed by all clients anyway.

ie. the host says "here's a port id 7", which might be the cut & paste
port or whatever.

Cheers,
Rusty.
