Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbXFAB3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbXFAB3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXFAB3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:29:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35298 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbXFAB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:29:37 -0400
X-Sasl-enc: oHXHxZgZCCU34SPGzbk+v421C+JCWHdlQ/GnOlOwvAB3 1180661373
Date: Thu, 31 May 2007 22:29:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Message-ID: <20070601012928.GD5407@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net> <20070531233326.GA1947@srcf.ucam.org> <20070601001304.GB5407@khazad-dum.debian.net> <20070601002435.GA2621@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601002435.GA2621@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Matthew Garrett wrote:
> On Thu, May 31, 2007 at 09:13:04PM -0300, Henrique de Moraes Holschuh wrote:
> > Well, we already produce KEY_UNKNOWN anyway, and the stuff you quoted above
> > just makes KEY_UNKNOWN useful for something instead of keeping it as an
> > useless notice to the user that some key (which one? who knows!) was
> > pressed.
> 
> Given existing userspace, it's never useful to generate KEY_UNKNOWN. 
> Adding extra information to the event doesn't alter that.

It will not break anything, and it is trivial to write an application to
intelligently handle KEY_UNKNOWN+scancode events.  This really is not a
reason to not do it, at all.

> > Perhaps what you dislike re. KEY_UNKNOWN is the part where KEY_UNKNOWN+scan
> > code is declared to be the prefered way to report keys that do not have a
> > specific function?  Your reply seems to indicate this, but I am not sure I
> > really understood what you meant.
> 
> Yes.

That could easily be removed or switched around but...

> > I am not exactly in love with the idea of using KEY_UNKNOWN in place of
> > stuff like KEY_FN_F1 either (I'd prefer to just bump up KEY_MAX and have
> > more posicional keycodes), but Dmitry is being quite clear that he does not
> > want to increase KEY_MAX to add more positional keycodes.
> 
> I think using positional keycodes would also be a mistake. We just need 
> a slightly larger set of keycodes representing user-definable keys. 
> There's 4 of them already - I really can't imagine there being many 
> keyboards with a significantly larger set of unlabelled keys.

I had this exact PoV, too, until Dmitry reminded me that keycodes are
*global* to the system in practice, and that different keys (as in keys that
have no correlation between their position, labels or lack thereof, and
function) in different input devices would end up mapped to KEY_PROGx by
default.

And in that scenario, KEY_UNKNOWN (i.e. "please remap me to what you want
this key to do for real") makes a lot more sense, given that we don't have
all the positional keycodes we need, and more are not being added.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
