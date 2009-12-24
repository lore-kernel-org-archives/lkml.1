Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZLXEuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZLXEuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZLXEuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:50:20 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:34022 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753011AbZLXEuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:50:20 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: uY5VAy8VM1nJNygRipfJZQw.NLZpL4_6Ux5kaU6MLPnCuJQPQqAteDlfp22pB5RPz_Jofw2wlZRFMVitgU_hH2QTFUv6L3NqHarnIspluemlFdR9UnYUsq1ccJRfsqzOS.dWFOsfXgOs7K2WHuijcrXK0_I3r.rmUJ09O9g.d6bYJMmk45EWdBd90b6NeRv_aC4hUXsS9HX.n.iRb8_PeIUblRUc3mD_g6NxVHvC7pl.Ge4hzWnGLHO0HzpksT8wwgkxzLNHZZ2EvTazfRs-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B32F304.4040609@schaufler-ca.com>
Date: Wed, 23 Dec 2009 20:50:12 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Michael Stone <michael@laptop.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: A basic question about the security_* hooks
References: <20091224022902.GA24234@heat>
In-Reply-To: <20091224022902.GA24234@heat>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone wrote:
> Dear kernel folks,
>
> There are a variety of places where I'd like to be able to get the
> kernel to
> return EPERM more often [1]. Many of these places already have
> security hooks.

That should make it easy!

>
> Unfortunately, I don't feel that I can make effective use of these hooks
> because they seem to be "occupied" by the large mandatory access control
> frameworks.

The only reason that your use might not be effective is if
you want to integrate with one or more of those frameworks.
Go ahead and use the LSM for your own nefarious purposes, that
is what it is there for. The whole point of the LSM is that
no two projects could agree on the right approach for moving
security forward. Heavens to Betsy, none of the existing
LSMs have demonstrated themselves as the Way and the Light.

The current set of hooks have grown as needed, primarily driven
by the needs of SELinux, the largest of the Mandatory Access
Control frameworks. Most recently growth has matched the needs
of TOMOYO.

> I'm hoping that you can tell me why this state of affairs persists.

Serious security models, including Type Enforcement, Bell
and LaPadula, Biba, Clark/Willson, Simple Separation, and
Green Light Ice remain the interest of a very small fragment
of the lunatic fringe of computer system deployments. So
long as the mechanism that supports this small but vocal
community is adequate to the task and easy for the rest
of the Linux universe to ignore everyone is more or less
content.

>
> More specifically, now that LSMs are statically linked, why is it good
> for the
> security hooks to call into a single monolithic "security_ops" struct
> instead
> of cheaper and simpler alternatives?

By all means, suggest an implementation ...

>
> In particular, what would be worse about a kernel in which each
> security hook
> contained nothing but conditionally-compiled function calls to the
> appropriate
> "real" implementation functions with early-exit jumps on non-zero
> return codes?

The question is not would it be worse, the question has to be
whether it would be better. In particular, would it be better
for the people who want nothing whatever to do with an LSM,
which remains by far the larger set of people.

>
> Thanks,
>
> Michael
>
> [1]: Two examples include my recent network-privileges patches and Eric
> Biederman's suggestions on how to make unprivileged
> unshare(CLONE_NEWNET) safe.
> I have little doubt that I'd think of more if I thought that the
> security hooks
> were accessible to me.

You're arguing for stacking a set of small security modules. This
is a direction that has gotten slammed pretty hard in the past but
that crops up every time someone like you comes along with a
module that serves a specific purpose. Mostly the objections have
come from people who will tell you that something else already
does what you're trying to do, and that all you have to do is take
on the entirety of their monolithic approach and you'll be happy.

I'm behind you 100%. Use the LSM. Your module is exactly why we have
the blessed thing. Once we get a collection of otherwise unrelated
LSMs the need for a stacker will be sufficiently evident that we'll
be able to get one done properly.


And just in case it matters, I understand that this is an unpopular
position. I am an advocate of progress, not necessarily my own
peculiar notions of computer security. I believe that we should keep
trying new things for the simple reason that in the twenty plus
years that I've been working on the problem no one has demonstrated
a solution that addresses more than a fraction of the whole. Lots of
great ideas have gotten discarded because they didn't fit into an
MLS system, SELinux, the Linux file system semantics, or the teeny
tiny little minds that control the IETF.



