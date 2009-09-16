Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZIPN7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZIPN7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZIPN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:59:41 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:39798 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZIPN7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <20090916131543.GA21107@infradead.org>
References: <20090915181247.GA32167@kroah.com> <20090916124533.GA11222@infradead.org> 
	<20090916125919.GA24154@suse.de> <20090916131543.GA21107@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 16 Sep 2009 15:59:29 +0200
Message-ID: <ac3eb2510909160659u776f8268x2b792938f119653c@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core patches for 2.6.31-git
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 15:15, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Sep 16, 2009 at 05:59:19AM -0700, Greg KH wrote:

> It's a very bad way to expose kernel state, and the same problem the
> original devfs had.  A good kernel state filesystem is immutable to
> changes from userspace, that is fully controlled by the kernel.  The
> problem with devfs and your new devfstmpfs is that you have both
> userspace and the kernel manipulating the same object.  Which for
> example makes life time management impossible.

It's well defined. When the device goes away, the node is removed, in
the same way the sysfs device is removed, and if userspace has
created/replaced the node, it has control over it and the kernel does
not touch it anymore. There is no known problem with that and no
difference how udev works today on all common systems.

If wanted, at the time you guys come up with a working union-mount, we
can make the kernel-maintained dev-filesystem read-only and mount a
tmpfs on-top of it. But we are not there at the moment.

> I also know who gladly killed it

And for good reason. The naming scheme was as wrong as it could be. We
have a completely different situation today.

> just to re-introduce the same thing years later,

It's not the same at all. There is udev today, and a well-defined way
to work with /dev, synchronized across all distros. Nothing really
changes with devtpmfs, it just gets simpler, has less races, and is a
lot more reliable.

It's a logical extension to sysfs, not much more. We create all the
things in /sys, why shouldn't we create the few nodes too, and make
many things much easier?

Kay
