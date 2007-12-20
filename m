Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbXLTIEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbXLTIEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXLTIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:04:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46213 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXLTIEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:04:10 -0500
Date: Thu, 20 Dec 2007 00:02:59 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-ID: <20071220080259.GA30416@kroah.com>
References: <20071220003031.GA15129@kroah.com> <a8e1da0712192354k3bce177fi3d30b5737c7d7a9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712192354k3bce177fi3d30b5737c7d7a9e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:54:40PM +0800, Dave Young wrote:
> On Dec 20, 2007 8:30 AM, Greg KH <greg@kroah.com> wrote:
> > Thanks to everyone for your last round of review comments and changes to
> > the kobject documentation.
> >
> > I now have over 130 patches reworking the kset/ktype and kobject apis in
> > the kernel tree, and here is the updated documentation and example code
> > that shows how things work now.
> >
> > Things different from the last time around are the kobject_add() and
> > kobject_init() functions now take a bunch of required parameters, and
> > the kobject cleanup code is much more forgiving.
> >
> > I want to drop kobject_unregister() but as this patch series is so big
> > already, I think it's time to let it bake in -mm and push into 2.6.25
> > before attempting it.
> [--snip--]
> 
> Hi, greg
> 
> How about add a kobject_remove function and temporarily keep the
> kobject_unregister as below until the 2.6.25:
> 
> kobject_unregister(...)
> {
>        ...
>         kobject_remove();
>         kobject_uevent();
>         ...
> }

Actually, it's not needed at all.  Thanks to Kay's recent changes in the
tree, a simple kobject_put() is all that is needed.  The proper sysfs
cleanup and uevent will happen if necessary, no housekeeping by the
caller required.

So I'll just nuke kobject_unregister() as it's a simple replacement with
kobject_put() which will clean up the api even more :)

And I'll go update the documentation...

thanks,

greg k-h
