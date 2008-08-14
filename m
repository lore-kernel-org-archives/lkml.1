Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYHNPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYHNPpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYHNPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:45:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33291 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYHNPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:45:25 -0400
Date: Thu, 14 Aug 2008 17:46:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Greg KH <greg@kroah.com>, "Deguara, Joachim" <joachim.deguara@amd.com>,
       gregkh@ucw.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 3] x86: L3 cache index disable for 2.6.26
Message-ID: <20080814154605.GB27141@elf.ucw.cz>
References: <200807181603.52332.mark.langsdorf@amd.com> <200808131502.42611.mark.langsdorf@amd.com> <20080813234503.GA32154@kroah.com> <200808140843.44090.mark.langsdorf@amd.com> <20080814134457.GD2262@elf.ucw.cz> <6453C3CB8E2B3646B0D020C112613273C5AC6D@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC6D@sausexmb4.amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +        val |= 0xc0000000;
> > > +        pci_write_config_dword(dev, 0x1BC + index * 4, val 
> > & ~0x40000000);
> > > +        wbinvd();
> > > +        pci_write_config_dword(dev, 0x1BC + index * 4, val);
> > 
> > Should it do if capable() test before doing such stuff?
> 
> I don't think so.  If it got this far, it is an AMD processor
> from family 0x10 or later, so it has wbinvd().

No, I meant we should check for permissions. Filesystem permissions
are traditionaly not enough for stuff like this. if
(capable(CAP_ADMIN)) or something?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
