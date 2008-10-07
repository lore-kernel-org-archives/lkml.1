Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYJGEnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYJGEnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYJGEm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:42:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYJGEm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:42:57 -0400
Date: Tue, 7 Oct 2008 06:42:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
	(Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081007044237.GA6355@elte.hu>
References: <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006231002.GN3180@one.firstfloor.org> <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> > >  Well, perhaps, but the thermal trip point phenomenon seems unique 
> > > to this family of systems.  The other aspects of the problem do 
> > > not really matter anymore as we seem to have addressed them 
> > > robustly enough now.
> > 
> > When you need DMI entries you clearly haven't.
> 
>  You can't just break a piece of hardware randomly (setting the 
> thermal trip points based on an interrupt mask of an I/O APIC input is 
> certainly beyond the ACPI spec), hide its documentation and still 
> demand it to be supported correctly, possibly hurting all the other 
> good equipment.  Sorry -- you have to draw a line somewhere. [...]

agreed. This is a clear example of a complex and hard to track down BIOS 
bug - and even in this case we go out on a limb working it around.

The first approach to such problems is usually a DMI pattern based fix - 
they happen when we dont know the full scope of a particular problem yet 
but have a rough idea and want to react to bugs quickly.

PCI ID based quirks are preferred much more in the long run: DMI pattern 
matching does not scale as the DMI space is human-visible and hence 
changes frequently not for technical/hw-environment but for 
perception/PR reasons, hence it is far less reliable programmatically 
than the PCI ID space.

But PCI ID methods, while more intelligent, they lag behind a bit and 
depend on good cooperation with hw makers. As long as DMI pattern 
matches end up turning into PCI ID based approaches, like here, i'm not 
complaining as a maintainer ;)

Thanks Maciej for your excellent in-depth analysis of this issue, and 
for your many fixes in this area of code - you squashed many difficult, 
long-standing bugs in this space.

	Ingo
