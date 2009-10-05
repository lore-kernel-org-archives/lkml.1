Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZJEOXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZJEOXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZJEOXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:23:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZJEOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:23:05 -0400
Date: Mon, 5 Oct 2009 07:22:01 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Colin Guthrie <cguthrie@mandriva.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: get_device_parent() race bug
Message-ID: <20091005142201.GA21891@kroah.com>
References: <4ABC7DB5.9010402@kernel.org> <4AC7EDD7.3080906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC7EDD7.3080906@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 09:35:35AM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Hello, Greg, Kay, Guthrie.
> > 
> > This problem was reported in bko#14023.  (aiee.. again, sorry about
> > the delay)
> > 
> >   http://bugzilla.kernel.org/show_bug.cgi?id=14023
> > 
> > sysfs is creating several devices in cuse class concurrently and with
> > CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.
> > 
> >  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> 
> Ping.  This one needs to be fixed in -stable.  It can be triggered by
> other char devices too.

Sorry, been slowly catching up...

This can be triggered by char devices?  Huh?  How?  I don't see the
failure path that is happening here.

And char devices shouldn't really be using the kobject at all, except
for a very basic reference count.

I keep threatening to rip kobject out of a char device and just use a
kref, as that is all that is really needed.  Well, that and the kmap
stuff, but again, it's not a "real" kobject being used there...

Perhaps now is the time to do this.

thanks,

greg k-h
