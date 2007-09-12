Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXILXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXILXI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXILXIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:08:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982AbXILXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:08:47 -0400
Date: Wed, 12 Sep 2007 16:08:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Kees Cook <kees@ubuntu.com>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
Message-Id: <20070912160827.e359a53b.akpm@linux-foundation.org>
In-Reply-To: <20070912215356.GC23294@kroah.com>
References: <20070912064134.GO7910@outflux.net>
	<46E7C91D.3070001@garzik.org>
	<b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	<20070912215356.GC23294@kroah.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 14:53:56 -0700
Greg KH <greg@kroah.com> wrote:

> On Wed, Sep 12, 2007 at 03:48:49PM +0400, Alexey Dobriyan wrote:
> > On 9/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> > > Kees Cook wrote:
> > > > This patch against 2.6.23-rc6 fixes a couple drivers that do not
> > > > correctly terminate their pci_device_id lists.  This results in garbage
> > > > being spewed into modules.pcimap when the module happens to not have
> > > > 28 NULL bytes following the table, and/or the last PCI ID is actually
> > > > truncated from the table when calculating the modules.alias PCI aliases,
> > > > cause those unfortunate device IDs to not auto-load.
> > > >
> > > > Signed-off-by: Kees Cook <kees@ubuntu.com>
> > >
> > > ACK
> > 
> > I mut say, non-terminated PCI ids lists are constant PITA. There should be
> > a way to a) put it in macro[1], so that terminator automatically added, and
> > b) still allow #ifdef inside table like, e.g. 8139too does.
> > 
> > [1] or not macro, because #ifdef inside macros aren't allowed.
> 
> If you know of a way to do this in an easier manner, patches are always
> gladly accepted :)

Change (ie: fix) the APIs to take a `length' arg, then fix up 10^42 drivers.

Oh, you said "easy" ;)

Perhaps there's some clever way in which we can check that the tables are
correctly terminated.  I guess some static code-checker could do it.  A
weaker option would be to do some runtime hack which carefully walks the
table and checks stuff.

