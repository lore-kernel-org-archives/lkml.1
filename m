Return-Path: <linux-kernel-owner+w=401wt.eu-S1422823AbXBUTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422823AbXBUTWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422824AbXBUTWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:22:35 -0500
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:38468 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422823AbXBUTWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:22:33 -0500
Date: Wed, 21 Feb 2007 10:12:02 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070221151202.GE22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl> <45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain> <45DC5E67.8060101@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC5E67.8060101@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 03:59:51PM +0100, Udo van den Heuvel wrote:
> But the IRQ for the DVB-T card doesn't work.
> I would need to test the DVB-T card alone to be sure it has working IRQ.
> If so, what would be the conclusion?

Well the BIOS makes an assumption about the irq routing on the board,
and assigns the IRQ based on that assumption.  Via's assumptions are
different than the assumptions of the maker of your riser board.  That
certainly makes sense given how the via ext-pci riser is explicitly
labeled as only compatible with via mini-itx boards, which really also
implies that no other riser card would be compabitle with a via mini-itx
board unless it is a universal card with a proper pci bridge chip (And I
have seen embedded boards that don't work correctly with those either,
but those are simpler to deal with in software, which is actually what I
had to do).

> What IRQ rerouting would I need to try? 1 of 3 choices?
> Or one best bet?

Well best bet is to find out if INTA on the PCI controller matches INTA
on the PCI slot.  If it does then you want the interrupts on both slots
to match.  If it doesn't then you want to undo whatever the mapping to
the slot is to make it match INTA on the slot to INTA on the bus
(assuming that is what Via means by DN19 uses INTA).

--
Len Sorensen
