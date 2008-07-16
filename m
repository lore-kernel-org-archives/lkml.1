Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbYGPNVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbYGPNVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYGPNV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:21:28 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49415 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755506AbYGPNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:21:27 -0400
Date: Wed, 16 Jul 2008 09:21:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: pageexec@freemail.hu
Cc: Tiago Assumpcao <tiago@assumpcao.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716132112.GR8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, pageexec@freemail.hu,
	Tiago Assumpcao <tiago@assumpcao.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <487D6AB9.7080700@schaufler-ca.com> <487DDC78.2960.1EAE7F08@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487DDC78.2960.1EAE7F08@pageexec.freemail.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:33:12AM +0200, pageexec@freemail.hu wrote:
> > > That's fallacious. Assuming that you have good programmers, and you 
> > > do, it's of very low cost the act of identifying what *is likely to 
> > > be* a security bug.
> > 
> > That is based on lots and lots of assumptions that are just not true.
> > Ted Tso, Stephen Smalley and I are all recognized as security experts
> 
> not so quick. security is a big field, noone really can claim to be
> a general expert. Ted knows kerberos but he would be unable to exploit
> the task refcount leak bug fixed in 2.6.25.10. Stephen and you know
> MAC systems inside out but you too would be unable to exploit that bug.
> different domains, different expertise, despite all being 'security'.

As far as I am concerned, knowing how to exploit a task refcount leak
bug is a technician's job.  Sure, I can write code that given an
intercepted or stolen Kerberos srvtab/ketab file, how to forge
Kerberos tickets.  But at the end of the day, that's perhaps the least
important part of what a "Security Expert" has to do.  Bruce Schneier
has written about this extensively.

The important thing to recognize about security is that it is all
about tradeoffs.  How do you protect the System (which may consist of
one computers or multiple computers) given a particular threat
environment, given adversaries with different levels of capability,
given the consequences of a security breach, and how do you do it
within a given parameters of cost and usability?  

What a security expert might do is laugh at someone who is spending
all of their time and energy worrying about local escalation attacks,
when they discover that all of the network exchanges are unprotected
and on an insecure network.  Or, they might point out that you are
spending 10 times as much money and effort on securing a system as the
cost of a security breach, and that might not make sense either.

This is why there are so many arguments over security.  There are
disagreements over what deserves more focus and attention, and what is
and isn't worthwhile trading off against other things.  For example,
last I looked, PaX significantly reduces the chance of buffer overrun
attacks, but at the cost of cutting your address space in half and
forcing you to use a custom-built kernels since modules are not
supported either (which means no tools like Systemtap, as well).  For
some people, particularly on 32-bit systems, this is unacceptable.
But some people might consider that a valid tradeoff.

As another example, take for example some bug that might be able to
cause a local privilege escalation.  If the machine running that
particular kernel is part of a computing cluster which is totally
disconnected from the Internet, that bug is from a security point of
view totally irrelevant.

So to do a true security analysis about the seriousness of a bug
*always* requires some amount of context about what the capabilities
that the adversary might have (or might have acquired).  Given that
most systems these days are single user systems, a local privilege
escalation attack may not be as big a of deal in this day and age.
Many people draw their trust boundary around the entire computer.

At the end of the day, it is an engineering discipline, and it is all
about tradeoffs.  So while it is useful to have people who focus on
the security of a single box against adversaries who have local shell
access, it is very easy to lose perspective of the greater security
picture.  And someone like Linus who is worried about the overall
system, it's even easier to lose perspective.  Consider that there was
only one computer system that to my knowledge, ever managed to get
evaluated as passing the Orange Book A1 security requirements; and
that system was a commercial failure.  It took too long to bring to
market, it was too slow, and was too expensive.  It would be like
people assuming that you could always build a tank by putting more
armor on it, and that there is no such thing as "too much armor".
Same principle.

I have a theory which is that people who are focused on local system
security to the exclusion of all else have a high risk of becoming
unbalanced; they end up like Theo de Rant, frustrated because people
aren't paying attention to them, and that others aren't worried about
the same problems that they think are important.  But, the good news
of open source is that if you *do* care about local system security to
the exclusion of all else, including high SMP scalability, and wide
hardware support, etc., you can go use OpenBSD!  They may be much more
your type of people.  Or, you can pay for support for an enterprise
Linux distribution, where they do have people who will help you out
for it.  Hopefully their idea of security and priorities matches up
with your own, although I will note that some of the companies that
have focused exclusively on security to the exclusion of all else
(e.g. Trustix AS, Immunix) haven't necessarily done very well
commercially.

Regards,

						- Ted
