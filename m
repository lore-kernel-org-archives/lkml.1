Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXF2Oqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXF2Oqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXF2Oqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:46:31 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:46556 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756333AbXF2Oqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:46:30 -0400
X-YMail-OSG: KRGRFisVM1kxdQAj6n0gzZxiYRsZbC9k_f8aHol9rxqRnQjit.2VR3qZmOhgH57dpR5BJYwK.g--
X-RocketYMMF: rancidfat
Date: Fri, 29 Jun 2007 07:46:29 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: implement-file-posix-capabilities.patch
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <468498F3.5040001@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <368899.33325.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morgan <morgan@kernel.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Casey Schaufler wrote:
> >> Would there be a difference between that and setting either fI or fP
> >> (depending on your intent) to those caps, and setting fE=1 in Andrew's
> >> scheme?
> > 
> > Arg, you're making me think. The POSIX group went through this,
> > let me see if I can reconstruct the logic.
> > 
> > The main issue is one if there being a possible case where you
> > have a capability ignorant program that you want to exec with
> > a different fP and fE. On first glance it seems that since the
> > program is capability ignorant it can't matter. But what if your
> > capability ignorant program exec's a capability aware program
> > to perform a helper function? You may well want the first program
> > to have a capability that it does not use in fP (but not fE)
> > to pass along to the helper program. True, you could probably
> 
> I'm not sure I've quite flogged this horse to death yet.. :-)
> 
> In my other reply, I quoted the rules. Here they are again:
> 
>     pI' = pI
>     pP' = (X & fP) | (pI & fI)
>     pE' = pP' & fE
> 
> If program A exec()utes helper program B, then the only capabilities
> (p*') that B can get from A are a subset of A's pI set.
> 
> If A doesn't know about capabilities, then nothing about the fE value
> associated with the A program file can alter A's pI set and thus affect
> B. That is, nothing about the fE or fP value used to exec()ute A gets
> propagated through a subsequent exec() to B.
> 
> So far as I can see, to achieve the helper program support you are
> describing, the value of pI that program A (and thus program B) inherits
> will have to contain the relevant capabilities, and B will have to have
> a sufficient fI value to pick them up...
> 
> Incidentally, this is also where my request that we require (pP' >= fP)
> be true comes in. If a helper program (which may also be a legacy
> program) is used in a way that it is configured (via fP) to have powers
> that are denied to it (via X=cap_bset etc.,) then it should simply not
> be permitted to run (-EPERM). It should not have the opportunity to
> silently confuse itself (as was the case with sendmail when we tried to
> emulate setuid-0 behavior with capabilities a few years back).
> 
> > come up with a way to set the capabilities on the helper program
> > to account for this use, but there may be design and security
> > constraints that make doing so complicated. 
> 
> I've not seen anything yet to make be believe there is a case for a
> non-single bit fE value... Its a little ironic that I read all of the
> rationale I've been espousing in POSIX drafts - so far as I'm aware the
> only detail I'm mixing in there is the (pP' >= fP), -EPERM, thing.
> 
> If you or anyone can cite some counter examples, please do!

Nope, I'm fresh out. If the reality is that you get no added value
with a vector over a scalar I'm good with either scheme. Looks like
you've done the dilegance. I see no flaws in your logic. I suppose
I could argue for the vector in terms of compatability with Irix,
but I'll leave that to those who might care.

Thank you for both the work and the clear explainations.


Casey Schaufler
casey@schaufler-ca.com
