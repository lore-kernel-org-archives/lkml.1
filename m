Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYCXDZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYCXDZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 23:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYCXDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 23:25:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52536 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbYCXDZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 23:25:12 -0400
X-Sasl-enc: oW0gYDGSa94F27+1J+GojqXFiApk+mIVbL2KnifN9oLy 1206329111
Date: Mon, 24 Mar 2008 00:25:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Input: add flags bitfield
Message-ID: <20080324032510.GB3321@khazad-dum.debian.net>
References: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br> <1206136586.14058.1243686863@webmail.messagingengine.com> <20080322070955.GA10719@khazad-dum.debian.net> <200803232102.07268.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803232102.07268.dtor@insightbb.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2008, Dmitry Torokhov wrote:
> On Saturday 22 March 2008, Henrique de Moraes Holschuh wrote:
> > On Fri, 21 Mar 2008, Henrique de Moraes Holschuh wrote:
> > > But I'd prefer if joydev and mousedev did not bind to
> > > unknown+capabilities, just in case.  Looks like bad form to me, and
> > > might bite us back later on.  We can properly fix all drivers in-tree
> > > to have suitable types for joydev and/or mousedev binds, rfkill binds,
> > > and so on after all.
> 
> Ohne word - HID.

Bleh.  In that case, it will be too ugly to have it called a type, most
of the input devices will have a type of "generic", which is at the very
least damn ugly.

> That's why I thinkg unmarked should really be default and only few selected
> devices should set their type.

I do think unmarked should be the default, and if it is so hard to have
the emulation (and other handlers) ignore unmarked, we can leave that
active by default as well.  No problems here.

What I don't like is to call it a "input device type", and have bits on
it for joystick and mouse, which almost every mouse and joystick will
NOT set.

At that point, the difference between the bitfield with a handler
whitelist (with blacklist all others implied, "Cisco ACL-style"), and a
type bitfield is just in the name.  The difference from what I already
sent you would be the name, and inverted logic (I sent you a blacklist
patch, not a whitelist patch).

IMO, it doesn't make sense to leave people wondering why their HID
devices (and most other input devices) have a type of "generic", when
they indeed are mouses, joysticks, or whatever.

Another approach would be to call the flags bitfield "emulation type",
set it to "any" as default (all bits zeroed), add one bit for every
emulation-style handler we add (e.g. mousedev and joydev, but not
rfkill), and never bind a handler to a device which has that bitfield
nonzero, unless it has the emulation bit for that handler set.

Do you *really* want a device type bitfield?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
