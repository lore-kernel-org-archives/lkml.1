Return-Path: <linux-kernel-owner+w=401wt.eu-S935276AbXJQBcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276AbXJQBcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXJQBb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:31:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:42841 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXJQBbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kz/T5u+/51JZUfFCmBSTOagi2OgQwf56O4UZwaIuOSjrHu9wNzplemLBNYEZ1/OIo64J7EXxwuglyYxWe1IlDXCr6Cqt/1izeGZJr+ZUWF0vo0NJyNkI76gYxuNMlPnEI9SmrnJ6iHMVNVrRv7wov3bA2siv+IQOiecYMYvayTM=
Message-ID: <a8e1da0710161831o4029d691y5b2b12e99592b901@mail.gmail.com>
Date: Wed, 17 Oct 2007 09:31:54 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>,
       "Dave Young" <hidave.darkstar@gmail.com>, bbpetkov@yahoo.de,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
In-Reply-To: <20071016191323.GC24082@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016163348.GB24082@one-eyed-alien.net>
	 <Pine.LNX.4.44L0.0710161355150.9662-100000@iolanthe.rowland.org>
	 <20071016191323.GC24082@one-eyed-alien.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 10/17/07, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> On Tue, Oct 16, 2007 at 02:04:43PM -0400, Alan Stern wrote:
> > On Tue, 16 Oct 2007, Matthew Dharm wrote:
> >
> > > I haven't looked at this code at all, but neither approach feels right to
> > > me.
> > >
> > > How does this work at all?  Even if you load a driver later, wouldn't it
> > > call usb_set_interface(), which would call usb_create_sysfs_intf_files()
> > > and hit the same issue?
> >
> > usb_set_interface() is smart enough to remove the old interface files
> > before creating new ones, since it expects them to exist already.
> > Hence there's no problem in that scenario.
> >
> > But usb_set_configuration doesn't expect there to be any pre-existing
> > interface files, because there isn't even an interface until the
> > registration is performed.
>
> And I'm guessing that you can't call usb_create_sysfs_intf_files() until
> registration is performed, right?
>
> > The most important reason has to do with the endpoint pseudo-devices.
> > Different altsettings can have different endpoints, so those have to be
> > removed and re-created whenever the altsetting changes.
>
> Right, altsettings.  I forgot about those.  I only ever think in terms of
> multiple configurations.
>
> *grumble*
>
> If usb_set_interface() has to be smart enough to remove existing files
> first already, then I guess it's reasonably symmetric to have
> usb_set_configuration() have the same smarts.  Maybe they can share some
> common code, even.
>
> Matt
>
> --
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.net
> Maintainer, Linux USB Mass Storage Driver
>
> C:  Why are you upgrading to NT?
> AJ: It must be the sick, sadistic streak that runs through me.
>                                         -- Chief and A.J.
> User Friendly, 5/12/1998
>

Hi,
I prefer "remove then create".

But IMHO the sysfs or driver core layer should have such  functions to
set some bit for the sysfs files creating.

Regards
dave
