Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbYJTJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbYJTJ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYJTJ13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:27:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYJTJ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:27:29 -0400
Date: Mon, 20 Oct 2008 11:27:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, maluta_tiago@yahoo.com.br,
       lguest@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [Lguest] lguest: unhandled trap
Message-ID: <20081020092703.GB3538@elte.hu>
References: <713731.28571.qm@web50701.mail.re2.yahoo.com> <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu> <48FC36B9.6000704@goop.org> <20081020075333.GC798@elte.hu> <1224494055.9053.192.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224494055.9053.192.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> > Nevertheless if this is the only current roadblock for lguest then i 
> > wouldnt find it objectionable to make DMI scanning more robust that 
> > way - the two are complimentary. [ With an initial transitionary 
> > period of generating printks and WARN()s when we try to scan general 
> > RAM areas. ]
> 
> Wasn't there some concern about BIOSes which don't correctly reserve 
> their DMI tables? Or don't even have e820 maps? H. Peter once said:
> 
> > It's pretty standard for 0xf0000...0x100000 to be marked RESERVED in 
> > E820 on real hardware (including the system I'm typing on right 
> > now.) It is so marked to indicate that hardware cannot be mapped 
> > into that space.  However, you can't rely on this fact -- heck, you 
> > can't rely on E820 even existing on a real machine.  I have 
> > specimens of real-life machines that go both ways.

yes, that's a real concern, hence i suggested the printks and WARN()s to 
map such cases. And note that such problems are only an issue if it 
actually disables an essential DMI quirk. It's fair to say that if a box 
needs a DMI quirk to function properly that we can expect the BIOS to at 
least have a minimally correct memory map.

	Ingo
