Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYCYNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYCYNim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYCYNid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:38:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbYCYNid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:38:33 -0400
Date: Tue, 25 Mar 2008 14:38:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325133810.GA10044@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325131258.GC11359@logfs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> > The current visual inconsistency between subsystems makes the Linux 
> > kernel appear rather unpleasant and unprofessional to new kernel 
> > developers. This is not just embarrasing to us (we want to write the 
> > best OS on the planet), it is also actively harmful: such a 
> > "consistent style does not matter" stance turns away people who have 
> > taste and tends to attract people who have no taste - which i'm sure 
> > you'll agree with results in a deadly spiral if it gets strong 
> > enough.
> 
> I disagree with that assertion.  My favorite example of where
> CodingStyle has gone too far is this:
> 	for (i=0; i<10; i++)
> While the official document demands four extra spaces, I _hate_ them. 
> Whitespace offers visual grouping.  The lack of whitespace around the 
> binary operators emphasizes that one kind of grouping is stonger than 
> another.  Ever since this binary operator testament was added to our 
> Holy Canon, I started violating the coding style on purpose.  Imo this 
> is beyond silly.

you picked an borderline case without showing the full effects of your 
choice of style - but still even in this example you are wrong i 
believe. Look at how inconsistent this looks:

 	for (i=0; i<10; i++) {
		l = 10;
		if (k <= 10)
			k = 11;
	}

(the inconsistent 'i=0' versus 'l = 10')

so in your style we'd have to write it as:

 	for (i=0; i<10; i++) {
		l=10;
		if (k<=10)
			k=11;
	}

which, on one hand, looks unprofessional (in fixed width font), but on 
the other hand, the literals and operators are way too "close" to each 
other and operators are easily missed and mis-identified visually - 
causing bugs.

For example the 'k' and the '<=' operator may look visually similar and 
can be "blended", making it easy to skip over 'k=10' versus 'k<=10' - 
while 'k = 10' clearly stands apart from 'k <= 10'. [and syntax 
highlighting does not help with this particular problem]

in Documentation/CodingStyle it looks:

 	for (i = 0; i < 10; i++) {
		l = 10;
		if (k <= 10)
			k = 11;
	}

which is certainly reasonable and groups safely.

yes - you can have arguments one way or another, but there's nothing 
worse than maintainers each going towards their own _arbitrary_ and 
often clearly inferior coding style, which is inconsistent within the 
same file.

I at least make the point that i'm trying to converge to 
Documentation/CodingStyle. Is it arbitrary? Yes, to a fair degree, but 
it certainly conveys a very strong, unambiguous sense of taste.

	Ingo
