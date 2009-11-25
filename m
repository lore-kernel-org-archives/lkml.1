Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbZKYA4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbZKYA4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbZKYA4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:56:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571AbZKYA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:56:10 -0500
Date: Tue, 24 Nov 2009 16:51:16 -0800
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: alacrity tree build failure
Message-ID: <20091125005116.GA21858@suse.de>
References: <20091124185843.d2cab90c.sfr@canb.auug.org.au>
 <4B0C7D21.7010008@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0C7D21.7010008@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 04:41:05PM -0800, Jeremy Fitzhardinge wrote:
> On 11/23/09 23:58, Stephen Rothwell wrote:
> > Today's linux-next build (x86_6 _allmodconfig) failed like this:
> >
> > drivers/vbus/built-in.o:(.data+0x0): multiple definition of `dev_attr_modalias'
> > drivers/xen/built-in.o:(.data+0x46d0): first defined here
> >
> > Caused by commit 59aa8f441d27c8470764a513dafa46a77f33e953 ("vbus: add
> > autoprobe capability to guest").  The DEVICE_ATTR(modalias ...) should
> > probably be static.  I should probably be static in
> > drivers/xen/xenbus/xenbus_probe.c as well.
> >   
> 
> All those DEVICE_ATTR()s should be static in that case.  Indeed, I guess
> they should be almost universally?  Should DEVICE_ATTR() include the
> static?  (Hm, almost every instance in the kernel already has static; it
> should probably have been part of the definition from the start, but
> changing it now would cause a lot of churn.)

There are some "non static" usages, mostly to deal with stuff within a
module that takes more than one file.  They could probably all be fixed
up if someone really is bored :)

thanks,

greg k-h
