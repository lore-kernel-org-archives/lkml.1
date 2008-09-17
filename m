Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYIQCd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYIQCd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 22:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYIQCdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 22:33:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42898 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYIQCds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 22:33:48 -0400
X-Sasl-enc: Jfy93sBvA5QeD5ushGUS5v1XJmDqiUBcJTajWHmS2CO9 1221618826
Date: Tue, 16 Sep 2008 23:33:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917023334.GA1187@khazad-dum.debian.net>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916233240.GA18574@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Matthew Garrett wrote:
> that's not a criticism of anyone involved - the documentation's 
> confusing and there weren't any good examples of how it should be 
> implemented).

I sure hope you mean "the documentation WAS confusing"... because if it is
still confusing, I have not got any comments or ideas about how it could be
improved yet... (HINT!).

> The real question is how the LED state is supposed to be being toggled, 
> and what that's got to do with rfkill. I /think/ that the current state 
> of events is:
> 
> 1) User toggles state
> 2) State toggle is used by b43 to generate KEY_WLAN (this is broken)
> 3) rfkill-input toggles the rfkill state, changing the LED state in the 
> process

Actually 2 and 3 will fight each other, and weird things will happen.

> What *should* be happening is:
> 
> 1) User toggles state
> 2) b43 changes rfkill state (by using rfkill_force_state). The LED state 
> should also be changed in the process.

Correct.

However, rfkill_force_state() is NOT updating LED states (I just checked).
I will sleep on the issue, and send in a patch tomorrow.

This probably means a small patch to rfkill + Matthew's fixed patch to use
rfkill_force_state() in b43 will fix the regression in the right way.

I don't care either way which kind of fix goes to 2.6.27, though.

The proper fix for rfkill will be in two stages. A small fix now, and a
complete change on the LED handling to use the blocking notifier chain
instead later on (which will clean up rfkill code somewhat).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
