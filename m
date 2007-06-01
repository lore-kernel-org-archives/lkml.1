Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXFADdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXFADdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXFADdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:33:13 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:46543 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXFADdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:33:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMwALAwX0ZKhRO4UGdsb2JhbACHLohIAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Date: Thu, 31 May 2007 23:33:10 -0400
User-Agent: KMail/1.9.3
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <20070601012928.GD5407@khazad-dum.debian.net> <20070601014453.GA3711@srcf.ucam.org>
In-Reply-To: <20070601014453.GA3711@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705312333.11477.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2007 21:44, Matthew Garrett wrote:
> On Thu, May 31, 2007 at 10:29:28PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 01 Jun 2007, Matthew Garrett wrote:
> > > Given existing userspace, it's never useful to generate KEY_UNKNOWN. 
> > > Adding extra information to the event doesn't alter that.
> > 
> > It will not break anything, and it is trivial to write an application to
> > intelligently handle KEY_UNKNOWN+scancode events.  This really is not a
> > reason to not do it, at all.
> 
> It's not trivial at all. You need to introduce a mechanism for noting a 
> KEY_UNKNOWN keypress. It then needs to signal the user (dbus is probably 
> the best layer for this), but you need to ensure that you only signal 
> the user who is currently at the keyboard. This needs to be presented to 
> the user via some sort of UI, which will then need to signal some sort 
> of privileged process to actually change the keymap.

Not necessarily priveleged - you most likely already change ownership
of event devices to user who is logged at console (so your force feedback
joysticks work).

> When the user logs  
> out, you'll then need to unmap the key again and repeat as necessary for 
> any new user who logs in.

I think we should aim at the most common case - when there are no multiple
users on the box. Then the utility that detects KEY_UNKNOWN just saves the
mapping user chose and automatically reload keymap upon next reboot.

Note that KEY_UNKNOWN solution does not preculde futher customization on
per-user base once default action is established.

> 
> Alternatively, we could generate a keycode and then let the user map 
> that to an X keysym. We've even already got code to do this.
>

There is world outside of X.
 
> > > I think using positional keycodes would also be a mistake. We just need 
> > > a slightly larger set of keycodes representing user-definable keys. 
> > > There's 4 of them already - I really can't imagine there being many 
> > > keyboards with a significantly larger set of unlabelled keys.
> > 
> > I had this exact PoV, too, until Dmitry reminded me that keycodes are
> > *global* to the system in practice, and that different keys (as in keys that
> > have no correlation between their position, labels or lack thereof, and
> > function) in different input devices would end up mapped to KEY_PROGx by
> > default.
> 
> That's a ridiculously niche case, and can be handled in userspace. Just 
> have udev do remapping when it detects multiple keyboards that both have 
> KEY_PROG* layers, or let X have different keymaps for different input 
> devices. We shouldn't make the (by far) common case significantly more 
> difficult to deal with this one.
> 

No, it is not a niche case. I think it is much more common than the case where
you have multiple users for the same box using different keymaps. Even if box
is shared there most likely will be one person setting it up in the beginning
and the rest will follow his/her setup.

-- 
Dmitry
