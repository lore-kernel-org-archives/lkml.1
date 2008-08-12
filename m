Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYHLWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYHLWGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHLWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:06:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38249 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYHLWGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:06:03 -0400
Date: Wed, 13 Aug 2008 00:07:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: Greg KH <greg@kroah.com>, "Deguara, Joachim" <joachim.deguara@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 1] x86: L3 cache index disable for 2.6.26
Message-ID: <20080812220722.GE12911@elf.ucw.cz>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080808220011.GA12156@ucw.cz> <200808121104.09288.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz> <6453C3CB8E2B3646B0D020C112613273C5AC68@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC68@sausexmb4.amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > +        for (i = 0; i < 2; i++) {
> > > +                unsigned int reg = 0;
> > > +
> > > +                pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
> > > +
> > > +                ret += sprintf(buf, "%s %x\t", buf, reg);
> > > +        }
> > > +	ret += sprintf(buf,"%s\n", buf);
> > 
> > So you print "buf" few times? Why? And you use both \t and \n 
> > as deliminer...
> 
> I'm printing the values of the two config registers into
> the string buffer, separated by tabs, and terminated by
> an EOL.  Is there a prefered way to do that instead of
> what I have?

Hmm, I misparsed that.

Yes, we have some helpers for sysfs writing... 	SEQ_printf(), IIRC.

Is this even valid C?

ret += sprintf(buf, "%s %x\t", buf, reg);

You are printing into buffer you are passing as argument. That seems
fragile.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
