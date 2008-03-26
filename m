Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYCZQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYCZQRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYCZQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:17:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34861 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYCZQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:17:28 -0400
X-Sasl-enc: xauJXZVcSz1anMp9NGWngPdjDVhzfqWMwABLTcrOOwCl 1206548246
Date: Wed, 26 Mar 2008 13:17:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, rpurdie@rpsys.net, gitster@pobox.com,
       corbet@lwn.net, mingo@elte.hu, mb@bu3sch.de,
       linux-kernel@vger.kernel.org, khali@linux-fr.org, geert@linux-m68k.org,
       akpm@linux-foundation.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080326161724.GA3562@khazad-dum.debian.net>
References: <20080325232042.4EDA7346532@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <Pine.LNX.4.44L0.0803261027580.4969-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803261027580.4969-100000@iolanthe.rowland.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Alan Stern wrote:
> On Tue, 25 Mar 2008, David Brownell wrote:
> > I _almost_ hate bringing this lovely flamage back onto $SUBJECT ... but
> > what's the resolution for the leds-gpio.c issue?  I've not seen a merge
> > notice for the patch I submitted a week ago now:
> > 
> > 	http://marc.info/?l=linux-kernel&m=120597839009399&w=2
> > 
> > Just a "leaning..." comment:
> > 
> > 	http://marc.info/?l=linux-kernel&m=120606104619198&w=2
> > 
> > Seems to me that by now there ought to be resolution on at least
> > one of the issues brought up on this thread.  :)
> 
> Is it reasonable to have two version of that subroutine: one meant to 
> be called in a sleepable context and the other to be called when 
> sleeping isn't allowed?

I have changed the thinkpad-acpi leds code to always assume an atomic
context, but I too would appreciate a proper flag (or secondary hook)
from the LED class to know when I am in an atomic context or not.

LED Triggers also need to be modified, they are mostly called from an
atomic context so we have to assume that by default, but we'd do well to
add a way to call them from non-atomic contexts.

Richard?  AFAIK, the ball *is* in your court as the LED maintainer.  You
have to decide which way to go and tell us.  I suppose either I or Alan
could write up patches to implement it, but I have better things to do
than to write patches that would be rejected anyway... OTOH, I don't
mind writing ones that I know are at least attempting to implement an
approved idea and would be rejected only if they need some fixing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
