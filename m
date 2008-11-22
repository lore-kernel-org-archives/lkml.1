Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYKVGpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYKVGpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 01:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYKVGpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 01:45:06 -0500
Received: from ns1.suse.de ([195.135.220.2]:50274 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYKVGpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 01:45:04 -0500
Date: Fri, 21 Nov 2008 22:41:32 -0800
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: linux-next: rr tree build failure
Message-ID: <20081122064132.GA6196@suse.de>
References: <20081121141913.90d05091.sfr@canb.auug.org.au> <200811212128.52317.rusty@rustcorp.com.au> <20081121183403.GC16353@suse.de> <200811221301.07058.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811221301.07058.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 01:01:06PM +1030, Rusty Russell wrote:
> On Saturday 22 November 2008 05:04:03 Greg KH wrote:
> > On Fri, Nov 21, 2008 at 09:28:51PM +1030, Rusty Russell wrote:
> > > Greg, here's the complete patch I have now:
> > >
> > > Subject: USB: Use core_param.
> > >
> > > Found this when I changed args to __module_param_call.  We now have
> > > core_param for exactly this.
> > >
> > > This reverts to the 2005 (pre- aafbf24a) behaviour where "nousb" was
> > > not a module parameter, just a kernel command line parameter.  That's
> > > more sensible anyway.
> >
> ...
> > No, we need to keep that module parameter please, some distros and users
> > rely on it.
> 
> Fair enough.  Patch below does this as moduleparam.h suggests.
> 
> It still means that the paremeter appears in 
> /sys/module/kernel/parameters/nousb OR
> /sys/module/usbcore/parameters/nousb.

What's the "OR" part?  What determines where it goes?

> FYI, if Pete had discovered this __setup issue today, the correct fix would
> be:
> 1) core_param(nousb) for backwards compat.
> 2) module_param(disable) for modern users who want module/in-built symmetry
>    (ie. boot cmdline "usbcore.disable", and "modprobe usbcore disable")
> 
> 
> USB: Don't use __module_param_call
> 
> Found this when I changed args to __module_param_call.  We now have
> core_param for exactly this, but Greg assures me "nousb" is used as a
> module parameter, using the method suggested in moduleparam.h will
> have to do.

Is there a real reason why we need to change this at all?

> +/* To disable USB, kernel command line is 'nousb' not 'usbcore.nousb' */
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX
> +module_param(nousb, bool, 0444);

That undef seems hacky beyond belief.  How would one know to do this?

thanks,

greg k-h
