Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0CIK1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:27:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0CIK1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:27:01 -0500
Date: Tue, 9 Mar 2010 11:27:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Micki Balanga <micki@n-trig.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] USB: N-trig Finger Pen Multitouch fix
In-Reply-To: <48A28051AC6D7A48B64F28272458190324F4F3@Exchange-IL.n-trig.com>
Message-ID: <alpine.LNX.2.00.1003091119080.17799@pobox.suse.cz>
References: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com> <4B94541C.5090509@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190324F4F3@Exchange-IL.n-trig.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Micki Balanga wrote:

> I see quite a number of changes that handle the protocol better than my 
> version, would you be offended if I begin to absorb those and submit 
> joint patches?  I'm not sure about the proper etiquette for that.
> 
> [Micki] As mentioned in my mail we have tested the driver with
> application develop by N-trig. 
> [Micki] Our user space application rely on these events, so if you want
> to make any change I will be happy if you 
> [Micki] consult me.

Please keep in mind that we don't want to break backwards compatibility 
for existing users of the current in-kernel n-trig driver.

> What user space tools have you tested this driver with?  It does not 
> seem to work well with the wacom and evdev drivers.
> 
> [Micki] We will put on N-trig web site a DEB package

Distributions based on Debian packaging system are not the only existing 
ones. What's usually better is to release source code package, so that 
distributions could eventually package it themselves for their users, if 
applicable.

> What improvements beyond the driver that's in 2.6.33 are you targeting?
> 
> [Micki] We will update the driver and user space application with new
> features.
>
> > + * The driver will support MTM firwmare Pen, Finger (Up to 6)
> 
> Is this code intended to support older firmwares as well?  It would be 
> best not to break the driver for users with legacy firmwares without 
> reason.
> 
> [Micki] There will be a DEB package for firmware upgrade.

The in-kernel driver needs to support both older and newer firmware at the 
same time, otherwise it would bring a lot of pain to users.

> > +                       case HID_DG_CONTACTCOUNT:
> > +                               nt_rpt->real_fingers = value;
> > +                               nt_rpt->fake_fingers =
> > MAX_FINGERS_SUPPORT - value;
> 
> > +                                               if
> (MAX_FINGERS_SUPPORT
> > == nt_rpt->fake_fingers--) {
> 
> Would you care to explain "fake_fingers"?  I'm not really seeing why it
> helps
> when you already have real_fingers.  It looks like you use that to
> detect some
> ghost events, but really again, fingers should be fine at that point.
> 
> That does remind me that I pulled that special case when I cleaned up my
> last
> patch set and forgot to put it back.
> 
> Are the fake finger events intentional or just a bug?
> [Micki] As I mentioned before we developed a user space application
> which analyze the data 
>         Transferred from driver and the driver need to report about fake
> fingers.

I am afraid this will need much more explanation.

Also, have you considered wrokign with X evdev people, so that ideally no 
other userspace software would eventually be needed?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
