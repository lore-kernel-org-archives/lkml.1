Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYIPWhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYIPWhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPWhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:37:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37874 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYIPWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:37:39 -0400
X-Sasl-enc: vbBdNXGl/1dmbzP6TLsgw7QkfTkl3SatwihTMYnNbSPV 1221604657
Date: Tue, 16 Sep 2008 19:37:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, bcm43xx-dev@lists.berlios.de,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080916223729.GC26035@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk> <200809162125.18978.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809162125.18978.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008, Michael Buesch wrote:
> But I don't know how to tell the rfkill subsystem about the states and

rfkill_force_state().  Must NOT be called from within atomic contextes,
something I haven't got around to find a proper way of fixing, and nobody
else seems to be on a rfkill coding frenzy right now.

> I'm still waiting for the sane rfkill API where we have three functions
> rfkill-allocate
> rfkill-hw-state-changed
> rfkill-free

I won't go on the rfkill-allocate/-free stuff, messing with that API means
you need to fix a lot of other people's drivers.  But you have the
rfkill-hw-state-changed now, it is called rfkill_force_state().  The only
crap is that it cannot be called from atomic contexts.

> months ago, but is now deprecated it seems (but I don't know what it it
> replaced by) is just so really confusing.

Read Documentation/rfkill.txt.  And the kernel-doc comments on rfkill.c.
The rfkill documentation was updated.

If you still have doubts after reading the stuff above, ask on
linux-wireless and CC me.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
