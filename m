Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYIRMne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYIRMne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYIRMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:43:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44046 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbYIRMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:43:24 -0400
X-Sasl-enc: CIwqHSMDTM0LpLa7bpl1B1ldfVGbwj142Wt8jAvkZlrq 1221741803
Date: Thu, 18 Sep 2008 09:43:18 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Michael Buesch <mb@bu3sch.de>, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH] rfkill: update LEDs for all state changes
Message-ID: <20080918124318.GB1583@khazad-dum.debian.net>
References: <20080917023334.GA1187@khazad-dum.debian.net> <1221682077-21170-1-git-send-email-hmh@hmh.eng.br> <48D16EDB.8090700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D16EDB.8090700@lwfinger.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > The LED state was not being updated by rfkill_force_state(), which will
> > cause regressions in wireless drivers that had old-style rfkill support and
> > are updated to use rfkill_force_state().
> > 
> > The LED state was not being updated when a change was detected through the
> > rfkill->get_state() hook, either.
> > 
> > Move the LED trigger update calls into notify_rfkill_state_change(), where
> > it should have been in the first place.  This takes care of both issues.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  net/rfkill/rfkill.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> >  John, this one is quite likely something that should be sent for
> >  merge in mainline BEFORE 2.6.27 is released.
> > 
> >  I am NOT sure it fixes regressions, that depends on whether the drivers
> >  using rfkill that are in 2.6.27 had working LED support before rfkill
> >  support was added to them.  Unfortunately, it cannot fix the b43
> >  regression by itself.
> 
> The b43 regression is not fixed with this patch and the one from
> Matthew that starts out with "Oh, hey, I suck. This one might stand a
> better chance of not falling over."

Curious.  My patch to rfkill WAS tested, and it DOES fix the same issue you
reported (hardware state changes to HARD_BLOCKED do not update the LEDs) in
thinkpad-acpi.  It is also an "obviously correct" patch.

What this probably means is that b43 would need a little more rfkill surgery
than what Matthew's patch already did.  I will look over Matthew's patch,
but my guess is that Michael's comments about the need to add some extra
code to b43 to actually synthesize the rfkill state from the separate HW and
SW rfkill input lines are a strong hint of where the problem might be.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
