Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbXFJU4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbXFJU4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXFJU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:56:09 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41903 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753831AbXFJU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:56:08 -0400
Subject: Re: Rules on how to use sysfs in userspace programs
From: Kay Sievers <kay.sievers@vrfy.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070610095643.c1435a74.randy.dunlap@oracle.com>
References: <20070608203637.GA9259@kroah.com>
	 <20070610140200.GD9726@thunk.org>
	 <20070610095643.c1435a74.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 22:55:47 +0200
Message-Id: <1181508947.4566.62.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 09:56 -0700, Randy Dunlap wrote:
> On Sun, 10 Jun 2007 10:02:00 -0400 Theodore Tso wrote:
> 
> > On Fri, Jun 08, 2007 at 01:36:37PM -0700, Greg KH wrote:
> > > The kernel exported sysfs exports internal kernel implementation-details
> > > and depends on internal kernel-structures and layout. It is agreed upon
> > > kernel developers, that the Linux kernel does not provide a stable
> > > internal API.  As sysfs is a direct export of kernel internal
> > > structures, the sysfs interface can't provide a stable interface too, it
> > > may always change along with internal kernel changes.
> > 
> > I want to step back and ask a very fundamental philosophical question
> > --- who are the intended users of sysfs?  If it exports an interface,
> > part of which is known not be stable, except for backwards
> > compatibility issues, why and to whom are we exporting them?
> 
> I agree that stepping back and asking questions is the right thing
> to do here.
> 
> /proc also reports lots of kernel internals, yet it is required
> to maintain compatibility.
> 
> ISTM that sysfs should allow additions, but only in ways that don't
> break backwards compatibility.  I.e., it should maintain backwards
> compatible interfaces when new ones are added.  Yeah, that means
> leave some crud around.  Yes, it may be as bad as /proc, but I've
> said that for quite awhile.

We try hard to keep the properties of the exported devices and the
classification directories stable, but sysfs is an one-to-one export of
the kernels object-model and unfortunately not a list of artificially
flat files like /proc. I don't see how a tree of directories, directly
created by a kernel that change that insanely fast, can be kept stable.

There is also a big difference to /proc: the /sys layout itself can even
change at runtime, some devices can be renamed, and others move around
and change their devpath in the tree while they are active. In /sys, the
_location_ of the information itself is not stable, only if you follow
some rules how to extract information from the tree, you will be able to
find it reliably.

Users need to follow some rules how to access information in the /sys
tree, and sure, it is far more complicated than reading /proc. That's
what this document tries to explain. It tries to document the rules,
kind of similar to the (simple and intuitive) rule for /proc, that files
need to be parsed for keys, instead of just assuming that the order of
information is always the same, or the content of the files always
contain the same keys.

Sysfs today exports all the completely useless implementation details of
the kernel. The recent changes, and the work-in-progress to move
everything into _one_ single device tree (/sys/devices) and _one_
symlinks-only based classification (/sys/subsystem) should make it much
easier to keep the same information around, even when things in the
kernel object-tree keep changing at the current rate. 

This document just tries to describe the real world today. If you have
any better idea, on how to export an internal device-tree from a kernel
that changes every hour and subsystems come and go, get replaced and get
changed all the time, we are more that happy to improve things here. :)

Thanks,
Kay

