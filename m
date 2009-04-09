Return-Path: <linux-kernel-owner+w=401wt.eu-S936380AbZDIUIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936380AbZDIUIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934915AbZDIUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:08:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760413AbZDIUId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:08:33 -0400
Date: Thu, 9 Apr 2009 12:50:30 -0700
From: Greg KH <gregkh@suse.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com, bhutchings@solarflare.com,
       andi@firstfloor.org, herber@gondor.apana.org.au, chrisw@sous-sol.org
Subject: Re: [RFC PATCH v2 09/19] net: Add vbus_enet driver
Message-ID: <20090409195030.GA3453@suse.de>
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163128.32740.46975.stgit@dev.haskins.net> <20090409093710.10d63e39@s6510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409093710.10d63e39@s6510>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 09:37:10AM -0700, Stephen Hemminger wrote:
> > +static int tx_ringlen = 256;
> > +module_param(tx_ringlen, int, 0444);
> > +
> > +#undef PDEBUG             /* undef it, just in case */
> > +#ifdef VBUS_ENET_DEBUG
> > +#  define PDEBUG(fmt, args...) printk(KERN_DEBUG "vbus_enet: " fmt, ## args)
> > +#else
> > +#  define PDEBUG(fmt, args...) /* not debugging: nothing */
> > +#endif
> 
> Why reinvent pr_debug()?

Even more important, use dev_dbg() instead please, that uniquly
describes your device and driver together, which is what you need/want,
and it ties into the dynamic debug work, so you don't need a special
kernel config option.

thanks,

greg k-h
