Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXFABpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXFABpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbXFABpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:45:08 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:42007 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXFABpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:45:06 -0400
Date: Fri, 1 Jun 2007 02:44:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Message-ID: <20070601014453.GA3711@srcf.ucam.org>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net> <20070531233326.GA1947@srcf.ucam.org> <20070601001304.GB5407@khazad-dum.debian.net> <20070601002435.GA2621@srcf.ucam.org> <20070601012928.GD5407@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601012928.GD5407@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:29:28PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 01 Jun 2007, Matthew Garrett wrote:
> > Given existing userspace, it's never useful to generate KEY_UNKNOWN. 
> > Adding extra information to the event doesn't alter that.
> 
> It will not break anything, and it is trivial to write an application to
> intelligently handle KEY_UNKNOWN+scancode events.  This really is not a
> reason to not do it, at all.

It's not trivial at all. You need to introduce a mechanism for noting a 
KEY_UNKNOWN keypress. It then needs to signal the user (dbus is probably 
the best layer for this), but you need to ensure that you only signal 
the user who is currently at the keyboard. This needs to be presented to 
the user via some sort of UI, which will then need to signal some sort 
of privileged process to actually change the keymap. When the user logs 
out, you'll then need to unmap the key again and repeat as necessary for 
any new user who logs in.

Alternatively, we could generate a keycode and then let the user map 
that to an X keysym. We've even already got code to do this.

> > I think using positional keycodes would also be a mistake. We just need 
> > a slightly larger set of keycodes representing user-definable keys. 
> > There's 4 of them already - I really can't imagine there being many 
> > keyboards with a significantly larger set of unlabelled keys.
> 
> I had this exact PoV, too, until Dmitry reminded me that keycodes are
> *global* to the system in practice, and that different keys (as in keys that
> have no correlation between their position, labels or lack thereof, and
> function) in different input devices would end up mapped to KEY_PROGx by
> default.

That's a ridiculously niche case, and can be handled in userspace. Just 
have udev do remapping when it detects multiple keyboards that both have 
KEY_PROG* layers, or let X have different keymaps for different input 
devices. We shouldn't make the (by far) common case significantly more 
difficult to deal with this one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
