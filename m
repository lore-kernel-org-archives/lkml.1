Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZJZVex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZJZVex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZJZVew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:34:52 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:34543 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZJZVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wfFw1KyjqVbX91r9aZL22d47/rLXV3arUlG8qnYsu/JlhCPjYLO5Ko976+OQr2yVTc
         qGaVpuCstmEJtZKRCHSnFqVTHpMHWNdMxhRcs1p8TSfzobqWkQ4JFRBb0SEOLRwZOm5A
         MDQil7/CvORjpiiW3dwBJVIgx4tWE+kvVZV+U=
Date: Mon, 26 Oct 2009 14:34:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091026213450.GA19119@core.coreip.homeip.net>
References: <4AD31709.4000103@tremplin-utc.net> <20091012154846.GB7996@core.coreip.homeip.net> <20091012173551.GC10557@suse.de> <20091012183313.GC8345@core.coreip.homeip.net> <20091012185417.GA30342@suse.de> <20091013031741.GB2887@core.coreip.homeip.net> <20091018075127.GH3935@core.coreip.homeip.net> <20091018080238.GA13810@suse.de> <20091023020150.GA26723@core.coreip.homeip.net> <20091026205953.GB11665@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026205953.GB11665@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 01:59:53PM -0700, Greg KH wrote:
> On Thu, Oct 22, 2009 at 07:01:50PM -0700, Dmitry Torokhov wrote:
> > On Sun, Oct 18, 2009 at 01:02:38AM -0700, Greg KH wrote:
> > > On Sun, Oct 18, 2009 at 12:51:27AM -0700, Dmitry Torokhov wrote:
> > > > On Mon, Oct 12, 2009 at 08:17:41PM -0700, Dmitry Torokhov wrote:
> > > > > On Mon, Oct 12, 2009 at 11:54:17AM -0700, Greg KH wrote:
> > > > > > On Mon, Oct 12, 2009 at 11:33:13AM -0700, Dmitry Torokhov wrote:
> > > > > > > On Mon, Oct 12, 2009 at 10:35:51AM -0700, Greg KH wrote:
> > > > > > > > On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > > > > > > > > > So at least, unbind should fail as well as bind.
> > > > > > > > > >
> > > > > > > > > 
> > > > > > > > > That would be Greg's domain s it is driver core decision whether to
> > > > > > > > > allow unbinding platform devices registered with
> > > > > > > > > platform_driver_probe().
> > > > > > > > 
> > > > > > > > No, I do not see why that should not be allowed.
> > > > > > > > 
> > > > > > > 
> > > > > > > Because once you did unbind the device you are stuck (unless the driver
> > > > > > > is compiled as a module, but then you could just unload the module
> > > > > > > instead of unbinding). Disallowing unbind would allow discarding not
> > > > > > > only __devinit but __devexit sections when driver is built in which
> > > > > > > would make ebedded people happy[^Hier].
> > > > > > 
> > > > > > Yeah, good point.
> > > > > > 
> > > > > > Does anyone do bind/unbind with platform devices today?
> > > > > > 
> > > > > > If not, a patch changing this would be welcome.
> > > > > > 
> > > > > 
> > > > > How about this one?
> > > > > 
> > > > 
> > > > *ping* We need to resolve this, otherwise everyone who likes to rebind
> > > > i8042 in couse of STR/STD will be in trouble.
> > > 
> > > Sorry, am in Tokyo right now.
> > > 
> > > I like this patch, and will queue it up, but it's too late for .32, it
> > > will have to wait for .33.
> > > 
> > 
> > Greg,
> > 
> > I hope you will reconsider. The patch is extremely small but without it
> > I am afraid many people whose distributions blindly rebind i8042 on
> > suspend/resume will lose their keyboards and mice now that i8042 uses
> > platform_driver_probe()...
> 
> What distros do something like that automatically? 

It looks SUSE recommends to do so in one of the Wikis.. There certainly
lots of recommendations to do so in case of keyboard resume troubles all
over the forums (Ubunto, Gentoo, other random ones).

> And this patch will
> not solve that problem, just forbid it from happening, right?
> 

It will prevent unbind from happening so that users who have suspend and
resume working properly but who have bind/unbind in their suspend/resume
scripts regardless will not run into trouble.

This still leaves users whose suspend/resume don't work by default but I
would rather fix their boxes properly instead of relying on that
workaround.

-- 
Dmitry
