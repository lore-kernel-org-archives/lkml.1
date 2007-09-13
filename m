Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXIMBWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXIMBWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXIMBWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:22:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbXIMBWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:22:06 -0400
Date: Wed, 12 Sep 2007 18:21:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@ubuntu.com>
Cc: Greg KH <greg@kroah.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Message-Id: <20070912182144.89ee9411.akpm@linux-foundation.org>
In-Reply-To: <20070913004937.GM8183@outflux.net>
References: <20070912064134.GO7910@outflux.net>
	<46E7C91D.3070001@garzik.org>
	<b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	<20070912215356.GC23294@kroah.com>
	<20070913004937.GM8183@outflux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 17:49:37 -0700 Kees Cook <kees@ubuntu.com> wrote:

> On Wed, Sep 12, 2007 at 02:53:56PM -0700, Greg KH wrote:
> > On Wed, Sep 12, 2007 at 03:48:49PM +0400, Alexey Dobriyan wrote:
> > > On 9/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> > > > Kees Cook wrote:
> > > > > This patch against 2.6.23-rc6 fixes a couple drivers that do not
> > > > > correctly terminate their pci_device_id lists.  This results in garbage
> > > > > being spewed into modules.pcimap when the module happens to not have
> > > > > 28 NULL bytes following the table, and/or the last PCI ID is actually
> > > > > truncated from the table when calculating the modules.alias PCI aliases,
> > > > > cause those unfortunate device IDs to not auto-load.
> > > > >
> > > > > Signed-off-by: Kees Cook <kees@ubuntu.com>
> > > >
> > > > ACK
> > > 
> > > I mut say, non-terminated PCI ids lists are constant PITA. There should be
> > > a way to a) put it in macro[1], so that terminator automatically added, and
> > > b) still allow #ifdef inside table like, e.g. 8139too does.
> > > 
> > > [1] or not macro, because #ifdef inside macros aren't allowed.
> > 
> > If you know of a way to do this in an easier manner, patches are always
> > gladly accepted :)
> 
> This patch against 2.6.23-rc6 will cause modpost to fail if any device
> id lists are incorrectly terminated, after reporting the offender.

ooh, clever chap.

> +			fprintf(stderr,"%s: struct %s_device_id is %lu bytes.  The last of %lu is:\n", modname, device_id, id_size, size / id_size);

dude, bid on this: http://cgi.ebay.com/Wyse-WY55-General-Purpose-Serial-Terminal-No-Keyboard_W0QQitemZ230169388145QQihZ013QQcategoryZ51280QQssPageNameZWDVWQQrdZ1QQcmdZViewItem

(not allowed to use 132-column mode, either)
