Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbZBXCYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbZBXCYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZBXCYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:24:09 -0500
Received: from n6b.bullet.sp1.yahoo.com ([69.147.64.163]:36228 "HELO
	n6b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752296AbZBXCYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:24:08 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 328626.62470.bm@omp424.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BYvot1wT/Z75CHiFOi1qy9Z9lIQsT+IrHQzXHS276BjgtOwmWqPBarIiry+6OQ8edCCoCbvEcBGOe7h+7E/hk+k5DzVi53zb4L0abGSSCnaRPLMnKiRsjkBrAkqeFu2L7gFtNwZkXtlCgRB7nOFxRvP5trU6Rd7LConEq8+6zfk=  ;
X-YMail-OSG: HoZQCeMVM1naxuItpfI88Je8v6BZEQ0O5oTgPWMnmasrsWravqBtK87qb7c.fy17w93pmxFG7r3PJH2Rd02hnjEFsC2KSvWEOFXWobPFcnoCDAU8Tu2IiWGGG2D9pUes.PKboUktQlwcRsMrn5gx6x9r
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 23 Feb 2009 18:22:27 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231443.16334.david-b@pacbell.net> <20090224005536.GC3601@sirena.org.uk>
In-Reply-To: <20090224005536.GC3601@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902231822.27422.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Mark Brown wrote:
> > > Yeah, I kind of agree.  To avoid confusion from changing the names I'd
> > > be tempted to go for something like "regulator driver constraints" but
> > > it's not desparately nice.
> 
> > Hence my suggestion:  {regulator,machine,consumer} constraints,
> > going from bottom up.  They aren't driver constraints; they
> > are hardware constraints:  regulators can't supply arbitrary
> > voltages.
> 
> Trouble is that the term regulator gets very overloaded and causes
> confusion.

That's why one of the *first* jobs in architecture is to
ensure the terminology doesn't easily overload ... there's
always trouble when it isn't.  Despite early groans from
peanut galleries about "language lawyering" and "wanting
to code in C not English", etc.  ;)

Thing is, there's already overloading here.  Two types
of regulator -- "struct regulator_dev" wrapping hardware,
and the "struct regulator" is a client/consumer handle.
(And thus confusing to me, since it sounds like the more
fundamental concept, but instead it's a few layers up.)

If you're concerned about overloading terminology, then
best to address it sooner than later.  I've noticed you
using the "consumer", "machine", and "regulator" terms
more or less like I suggested, and those make sense; but
the current struct names don't encourage that usage.  It's
possible to adjust usage before changing names in "C".
Thankfully, in Linux global name struct changes are not
rejected out of hand.


> There's also fun and games to be had with accuracy once you 
> start looking too closely at the discrete voltages.

Yes; the patch I sent is explicitly making those available.

But I ignored issues like "+/- 3% accurate output" for LDOs
(or switchers) ... if anyone really needs to address them,
patches will be needed.  For now I only care that a 3.1 Volt
output can match both MMC_VDD_30_31 and MMC_VDD_31_32! ;)

- Dave



