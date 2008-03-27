Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYC0N3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYC0N3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYC0N2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:28:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38751 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbYC0N2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:28:48 -0400
Date: Thu, 27 Mar 2008 14:29:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327132923.GA12801@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu> <20080327084231.GC25876@elf.ucw.cz> <20080327095949.GA5771@elf.ucw.cz> <20080327114923.GA6589@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327114923.GA6589@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...this sounds like it needs to be done during resume, too, no?
> 
> This is only a workaround for BIOS that don't set up an aperture,
> but yes if they don't do that it is likely needed on resume too.
> 
> You would need to add a resume handler to aperture.c

Probably this needs to be redone during resume, right?

	/* Fix up the north bridges */
	for (num = 24; num < 32; num++) {
		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
			continue;

		/*
		 * Don't enable translation yet. That is done later.
		 * Assume this BIOS didn't initialise the GART so
		 * just overwrite all previous bits
		 */
		write_pci_config(0, num, 3, 0x90, aper_order<<1);
		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
	}

....plus the "enable translation" part... but where is that hiding?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
