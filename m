Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYLTXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYLTXys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 18:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYLTXyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 18:54:41 -0500
Received: from ns.suse.de ([195.135.220.2]:54569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYLTXyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 18:54:41 -0500
Date: Sat, 20 Dec 2008 15:31:40 -0800
From: Greg KH <gregkh@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: fix no_pci_devices() #2
Message-ID: <20081220233140.GA1505@suse.de>
References: <20081220105658.GA1760@localhost.localdomain> <20081220111419.GA5367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220111419.GA5367@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 12:14:19PM +0100, Vegard Nossum wrote:
> On Sat, Dec 20, 2008 at 11:56 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Sat, Dec 20, 2008 at 9:58 AM, Greg KH <gregkh@suse.de> wrote:
> >> Care to make a patch for no_pci_devices() to work properly in this kind
> >> of situation?
> >
> > How does this look?
> >
> > I have introduced a variable pci_is_initiated, which is set after the bus
> > has been registered.
> 
> This patch is simpler and also works for me. But I am not too fond of it
> either...
> 
> 
> Vegard
> 
> 
> >From 1f047c86fc7a831d85174452da92344a3582a158 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 20 Dec 2008 12:08:18 +0100
> Subject: [PATCH] pci: fix no_pci_devices() #2
> 
> In short, no_pci_devices() should not use bus_find_device() before
> initcalls have run, because the pci bus structure has not been
> initialized yet.
> 
> Reference: http://lkml.org/lkml/2008/12/20/21
> 
> Cc: Greg KH <gregkh@suse.de>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/base/bus.c  |    1 +
>  drivers/pci/probe.c |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 5aee1c0..5e83faf 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -931,6 +931,7 @@ bus_devices_fail:
>  bus_uevent_fail:
>  	kset_unregister(&bus->p->subsys);
>  	kfree(bus->p);
> +	bus->p = NULL;
>  out:
>  	return retval;

I like this portion anyway, care to break this out into a separate
patch and send it to me?

The first one also looks good to me, Jesse, feel free to add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
