Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYD2RMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYD2RMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYD2RLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:11:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:38776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYD2RLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:11:18 -0400
Date: Tue, 29 Apr 2008 09:56:22 -0700
From: Greg KH <gregkh@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stas Sergeev <stsp@aknet.ru>, Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch
	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
	added to gregkh-2.6 tree
Message-ID: <20080429165622.GA7230@suse.de>
References: <12094266793898@kroah.org> <4816A888.9000802@aknet.ru> <20080429045849.GA6348@suse.de> <s5habjdvt6z.wl%tiwai@suse.de> <20080429151436.GB10587@suse.de> <s5hr6cowr4f.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr6cowr4f.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:41:20PM +0200, Takashi Iwai wrote:
> At Tue, 29 Apr 2008 08:14:36 -0700,
> Greg KH wrote:
> > 
> > On Tue, Apr 29, 2008 at 12:41:56PM +0200, Takashi Iwai wrote:
> > > At Mon, 28 Apr 2008 21:58:49 -0700,
> > > Greg KH wrote:
> > > > 
> > > > On Tue, Apr 29, 2008 at 08:48:08AM +0400, Stas Sergeev wrote:
> > > > > Hello.
> > > > > 
> > > > > gregkh@suse.de wrote:
> > > > > > This is a note to let you know that I've just added the patch titled
> > > > > >      Subject: driver core: warn about duplicate driver names on the same bus
> > > > > > to my gregkh-2.6 tree.  Its filename is
> > > > > Thanks.
> > > > > 
> > > > > Takashi, do you think this fixes the
> > > > > pcspkr/snd-pcsp conflict sufficienly
> > > > > well? I think the Kconfig protection
> > > > > is no longer needed. For the better
> > > > > convinience the modprobe rule can be
> > > > > created that will remove one driver
> > > > > before inserting another. But this is
> > > > > optional.
> > > > 
> > > > No, don't rely on the driver core warning and catching code errors like
> > > > this, that's not a good idea at all.  I like the warning and your patch,
> > > > but don't assume it's always going to be there.
> > > 
> > > But multiple drivers for the same device are allowed on other buses
> > > like PCI.  I think this is no reason to prohibit the multiple platform
> > > drivers for the same platform device.
> > 
> > No, the driver core doesn't allow that at all right now (I'm working on
> > fixing that though...)
> > 
> > What this patch did is just not allow you to have the same "name" for
> > the driver on the same bus, which is reasonable as without the check,
> > sysfs complains about trying to create a duplicate name in the same
> > directory.
> > 
> > Different names is fine, and I'll continue to work on the ability to
> > allow multiple drivers for the same device at the same time...
> 
> Well, I wasn't clear enough -- currently we prohibit the *build* of
> snd-pcsp driver when input pcspkr driver is built, regardless whether
> module or built-in.  The reason is that sysfs spews an error with a
> stack trace when the platform name conflicts, and this appears to be a
> serious error.  Disabling the build is the simplest solution in such a
> case (when considering built-in driver).
> 
> Now, with this patch, the platform name conflict appears non-critical,
> and the driver should handle properly for the returned error code.
> Thus, there shouldn't be a big obstacle to *build* both drivers.

Ah, ok, that makes more sense :)

thanks,

greg k-h
