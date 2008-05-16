Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYEPNN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYEPNN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYEPNNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:13:48 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:15344 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYEPNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=B1KmC9Gu+7YiPxJEa5/zQBWQMz3Ddqm41VHMstyoQcXY3ibIoNKgeg0m2cUzlmZvG6tKIOC5Q/VRRqvoReuNXRO4VnkpdxmY+8XOHxdTelkobtKEGp9rSjPUWGTQQ11w6W4MZmaacgaUBogqNcDgaz+3szliHWg76O3PKWvdVIQ=
Date: Fri, 16 May 2008 09:13:41 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>, jkosina@suse.cz, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: add appleir USB driver
Message-ID: <20080516090351.ZZRA012@mailhub.coreip.homeip.net>
References: <20080514221519.GA6575@kroah.com> <20080515132108.GA9327@dose.home.local> <20080515094212.ZZRA012@mailhub.coreip.homeip.net> <20080515174939.GA10881@dose.home.local> <20080515142845.ZZRA012@mailhub.coreip.homeip.net> <20080515205950.GA11794@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515205950.GA11794@dose.home.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:59:50PM +0200, Tino Keitel wrote:
> On Thu, May 15, 2008 at 14:35:54 -0400, Dmitry Torokhov wrote:
> > On Thu, May 15, 2008 at 07:49:39PM +0200, Tino Keitel wrote:
> > 
> > > From the user's point of view: There are no official kernel release
> > > notes about what devices are added/removed to/from the various
> > > ignore lists and blacklists. The kernel doesn't produce any output
> > > about devices that are ignored or blacklisted in may cases (and
> > > also this one). The user has no indication why his LIRC setup stops
> > > working with the new kernel.
> > >
> > 
> > Not sure what we can do here... The only thing I guess is better
> > commit message mentioning LIRC setup concerns.
> 
> Who reads commit messages? I think it should be easy to add some
> printk()s saying something like "skipping device foo, because it is on
> the ignore list".

Then every user of Wacom tablet will be alarmed and ask "why my tablet
is ignored". The only thing that I can think of is making that quirk
compiled in depending on whether CONFIG_APPLEIR is selected.

> 
> > > Even if all LIRC users switch to the appleir driver, what about
> > > people who use a learning remote to have more than 6 keys that the
> > > Apple remote has? Does this work at all? After a quick look at the
> > > key handling it seems to me that the codes of the 6 keys are
> > > hardcoded in the driver. So a learning remote with more keys
> > > wouldn't work anymore.
> > >
> > 
> > We'll have to adjust the driver to allow changing keymap on a
> > per-device base from userspace. That's pretty easy actually.
> 
> I'm not talking about the keymap that is visible in userspace, but
> about the keys on the remote that are detected by the kernel. The Apple
> remote has only 6 keys, and they are mapped in a static array:
> 
> #define MAX_KEYS       8
> static int keymap[MAX_KEYS] = ...
> 
> With the LIRC driver, I can use a learning remote with much more keys,
> and then just use irrecord to create a LIRC config file.
> 

Does the learning remote have the same VID/PID as AppleIr? If not I am
not sure why you are btringing it here.

-- 
Dmitry
