Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYEOSgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYEOSgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764178AbYEOSgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:36:01 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:4774 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764171AbYEOSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kHBGUyxILUaR67O52cLZWQndtsXgTmdJSsKfO/uNraYwx3nrOAm5Q+uUqpM2DI5svnfIr8RNFbub6jlDOJ+/ZdOiZipg9c26iWAZpRFSXpKx5uUF/+rBbLim2UJpa22H6AjUy37UUSpBsesRA7iN2pGfWYP7UgCd830jp0oXFM8=
Date: Thu, 15 May 2008 14:35:54 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080515142845.ZZRA012@mailhub.coreip.homeip.net>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515174939.GA10881@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 07:49:39PM +0200, Tino Keitel wrote:
> On Thu, May 15, 2008 at 09:45:52 -0400, Dmitry Torokhov wrote:
> > Hi Tino,
> > 
> > On Thu, May 15, 2008 at 03:21:08PM +0200, Tino Keitel wrote:
> > > Hi,
> > >
> > > I'm pretty sure that this breaks the macmini LIRC driver again, see
> > > commit 3e1928e8793208802589aae851b6685671187242.
> > >
> > 
> > But with in-kernel driver can't LIRC feed of event device?
> 
> Sure, it can. But in its current state, it breaks existing scenarios
> and seems to have restrictions. See the comment below regarding
> learning remotes, and my other mail in this thread regarding broken
> suspend with the appleir driver.
> 

These needs to be fixed before it is in mainline, no argument here.

> > Ane people that dont use LIRC can also have access to the remote?
> 
> I know. I just wanted to point out that this is a regression for all
> people who use the macmini LIRC driver. This driver was present at
> least in the last 2 LIRC releases. The quirks stuff in the above patch
> looks like there is no way to make the macmini LIRC driver work with
> the patch applied. It relies on a USB HID device, which wouldn't be
> created anymore, and the user has no way to bring it back. Please
> correct me with a pointer to the appropriate documentation if I'm
> wrong.
>

There is a way to dynamically manipulate quirks for a VID/PID pair via
sysfs. I think if you set the quirk to 0 it will efefctively disable
the ignore quirk restoring the old behaviour.

> From the user's point of view: There are no official kernel release
> notes about what devices are added/removed to/from the various ignore
> lists and blacklists. The kernel doesn't produce any output about
> devices that are ignored or blacklisted in may cases (and also this
> one). The user has no indication why his LIRC setup stops working with
> the new kernel.
>

Not sure what we can do here... The only thing I guess is better
commit message mentioning LIRC setup concerns.

> Even if all LIRC users switch to the appleir driver, what about people
> who use a learning remote to have more than 6 keys that the Apple
> remote has? Does this work at all? After a quick look at the key
> handling it seems to me that the codes of the 6 keys are hardcoded in
> the driver. So a learning remote with more keys wouldn't work anymore.
>

We'll have to adjust the driver to allow changing keymap on a
per-device base from userspace. That's pretty easy actually.

-- 
Dmitry
