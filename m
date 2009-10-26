Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZJ0ACF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZJ0ACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZJ0ACE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:02:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:53283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZJ0ACD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:02:03 -0400
Date: Mon, 26 Oct 2009 16:59:08 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
 anymore
Message-ID: <20091026235908.GA12974@suse.de>
References: <20091012154846.GB7996@core.coreip.homeip.net>
 <20091012173551.GC10557@suse.de>
 <20091012183313.GC8345@core.coreip.homeip.net>
 <20091012185417.GA30342@suse.de>
 <20091013031741.GB2887@core.coreip.homeip.net>
 <20091018075127.GH3935@core.coreip.homeip.net>
 <20091018080238.GA13810@suse.de>
 <20091023020150.GA26723@core.coreip.homeip.net>
 <20091026205953.GB11665@suse.de>
 <20091026213450.GA19119@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026213450.GA19119@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 02:34:50PM -0700, Dmitry Torokhov wrote:
> On Mon, Oct 26, 2009 at 01:59:53PM -0700, Greg KH wrote:
> > On Thu, Oct 22, 2009 at 07:01:50PM -0700, Dmitry Torokhov wrote:
> > > On Sun, Oct 18, 2009 at 01:02:38AM -0700, Greg KH wrote:
> > > > On Sun, Oct 18, 2009 at 12:51:27AM -0700, Dmitry Torokhov wrote:
> > > > > On Mon, Oct 12, 2009 at 08:17:41PM -0700, Dmitry Torokhov wrote:
> > > > > > On Mon, Oct 12, 2009 at 11:54:17AM -0700, Greg KH wrote:
> > > > > > > On Mon, Oct 12, 2009 at 11:33:13AM -0700, Dmitry Torokhov wrote:
> > > > > > > > On Mon, Oct 12, 2009 at 10:35:51AM -0700, Greg KH wrote:
> > > > > > > > > On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > > > > > > > > > > So at least, unbind should fail as well as bind.
> > > > > > > > > > >
> > > > > > > > > > 
> > > > > > > > > > That would be Greg's domain s it is driver core decision whether to
> > > > > > > > > > allow unbinding platform devices registered with
> > > > > > > > > > platform_driver_probe().
> > > > > > > > > 
> > > > > > > > > No, I do not see why that should not be allowed.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Because once you did unbind the device you are stuck (unless the driver
> > > > > > > > is compiled as a module, but then you could just unload the module
> > > > > > > > instead of unbinding). Disallowing unbind would allow discarding not
> > > > > > > > only __devinit but __devexit sections when driver is built in which
> > > > > > > > would make ebedded people happy[^Hier].
> > > > > > > 
> > > > > > > Yeah, good point.
> > > > > > > 
> > > > > > > Does anyone do bind/unbind with platform devices today?
> > > > > > > 
> > > > > > > If not, a patch changing this would be welcome.
> > > > > > > 
> > > > > > 
> > > > > > How about this one?
> > > > > > 
> > > > > 
> > > > > *ping* We need to resolve this, otherwise everyone who likes to rebind
> > > > > i8042 in couse of STR/STD will be in trouble.
> > > > 
> > > > Sorry, am in Tokyo right now.
> > > > 
> > > > I like this patch, and will queue it up, but it's too late for .32, it
> > > > will have to wait for .33.
> > > > 
> > > 
> > > Greg,
> > > 
> > > I hope you will reconsider. The patch is extremely small but without it
> > > I am afraid many people whose distributions blindly rebind i8042 on
> > > suspend/resume will lose their keyboards and mice now that i8042 uses
> > > platform_driver_probe()...
> > 
> > What distros do something like that automatically? 
> 
> It looks SUSE recommends to do so in one of the Wikis.. There certainly
> lots of recommendations to do so in case of keyboard resume troubles all
> over the forums (Ubunto, Gentoo, other random ones).
> 
> > And this patch will
> > not solve that problem, just forbid it from happening, right?
> > 
> 
> It will prevent unbind from happening so that users who have suspend and
> resume working properly but who have bind/unbind in their suspend/resume
> scripts regardless will not run into trouble.
> 
> This still leaves users whose suspend/resume don't work by default but I
> would rather fix their boxes properly instead of relying on that
> workaround.

Ok, fair enough, I'll queue it up for .32.

thanks,

greg k-h
