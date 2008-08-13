Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYHMSUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYHMSUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHMSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:20:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYHMST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:19:59 -0400
Date: Wed, 13 Aug 2008 11:18:50 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080813181850.GD4886@kroah.com>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl> <alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl> <20080813005835.GE22793@kroah.com> <ea8d860a0808130016w646307few3cc6385caf9b1ec7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea8d860a0808130016w646307few3cc6385caf9b1ec7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 08:16:02AM +0100, Marcin Obara wrote:
> 2008/8/13 Greg KH <greg@kroah.com>:
> > On Mon, Aug 11, 2008 at 09:23:01PM +0200, Marcin Obara wrote:
> >> +/* IOCTL commands */
> >> +#define IOCTL_HECI_GET_VERSION \
> >> +    _IOWR('H' , 0x0, struct heci_message_data)
> >
> > This can easily be a sysfs file, why not do that instead?
> >
> sysfs file would require additional file handle used by every userspace client.

So, is that really a great overhead?

> GET_VERSION is called frequently

Why?  Shouldn't it only be called once?

>, and sysfs file would create extra overhead.

Have you measured it?

> With ioctl - only one file handle is used, and userspace client logic
> is simpler.

But the kernel is messier and we are trying to not add any more ioctls
to it.  Especially for trivial things like the version number of the
hardware device.

> Normal flow looks like:
> 
> open
> ioctl(GET_VERSION)

Great, do an additional open/read/close here for the version, I think
you will find it pretty trivial to do :)

thanks,

greg k-h
