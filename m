Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYHWPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYHWPpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 11:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHWPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 11:45:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYHWPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 11:45:22 -0400
Date: Sat, 23 Aug 2008 08:44:50 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080823154450.GA27985@kroah.com>
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org> <20080822195358.GC20820@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822195358.GC20820@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 01:53:58PM -0600, Alex Chiang wrote:
> * Matthew Wilcox <matthew@wil.cx>:
> > On Fri, Aug 22, 2008 at 10:20:49AM -0600, Alex Chiang wrote:
> > > This is a second attempt at creating some handy symlinks in
> > > /sys/bus/pci/ between slots and devices.
> > > 
> > > It addresses the following concerns from last time:
> > > 
> > > 	- does not create superfluous 'device' link
> > > 	- correctly adds and removes links after hotplug ops
> > > 	- adds a bunch of documentation ;)
> > > 
> > > It does not address Willy's concerns about not needing the
> > > functionN back-links.  I kinda thought they were useful, no one
> > > else seemed to express an opinion...
> > 
> > I was just explaining why I didn't create them when I did my version of
> > this patch.  I don't have an objection to adding them; they make logical
> > sense.  The only concern might be the additional memory usage.
> 
> Yes, agree about the memory usage, although I wonder what the
> actual overhead is.
> 
> Does anyone have numbers for how much it costs to create a new
> symlink? I could try and figure this out but it will take a few
> days (busy with other stuff).

Almost nothing.

sysfs creates these things on the fly as they are accessed, and if
memory pressure on the machine happens, they are freed up properly and
then created again if a user asks to see them in the tree.

So don't worry about memory issues when adding new files or symlinks in
sysfs, it just isn't a problem (we handle 20000 disks easily on low
memory 31bit s390 systems.)

thanks,

greg k-h
