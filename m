Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0CHJrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:47:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab0CHJrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:47:04 -0500
Date: Mon, 8 Mar 2010 10:46:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308094647.GA14268@elte.hu>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Thu, 4 Mar 2010, Linus Torvalds wrote:
> 
> > On Thu, 4 Mar 2010, Kyle McMartin wrote:
> >> 
> >> I recommend you don't look at Ubuntu, we might have a lot of extra
> >> crud[2] in the kernel if you do. :) (Actually, shockingly less than I
> >> thought, just apparmor, aufs, ndiswrapper are the obvious ones.)
> > 
> > Ok, so ndiswrapper falls under the "yeah, no" heading.
> > 
> > But apparmor was supposed to be on the "yeah, we'll merge it" path, I 
> > talked to somebody about it not _that_ long ago. Some of the security 
> > people object, but they object for all the wrong reasons and I really do 
> > think that since it's getting used, we really should merge it.
> 
> The AppArmor developer has been posting patches for review -- there's 
> nothing stopping the code being merged except for the need to address 
> purely technical issues raised by reviewers, which is ongoing.
> 
> See: http://thread.gmane.org/gmane.linux.kernel.lsm/10443
> 
> > Although there was _some_ noise about Ubuntu trying to move away from it.. 
> > But that may have been more of the whole FUD thing from the people who for 
> > some unfathomable reason think that inodes are more important than 
> > pathnames.
> 
> Hey, thanks for another random unfounded personal attack, it's really 
> appreciated.

Btw., now that we are a few reasonable months after the last big security 
flamewar it would be nice to see a rehash or fair summary of the pathname 
versus labels arguments. That particular issue does seem to be largely 
technical and thus we ought to be able to judge it one way or another.

IMO the main challenge in Linux security is to find and engage the right 
critical mass of developers to truly increase the security of 'Linux' as a 
whole in the long run.

That means, almost by definition, that we do not start by trying to create an 
'as secure as possible' system in the short run. Increased security is the 
_end goal_, not the means. I.e. we need a technology _process_ that results in 
more secure Linux systems.

( Trying to create an 'as secure as possible' system will almost certainly 
  backfire, as it results in _fewer_ developers/users caring. )

In that sense it appears to me that it's pretty much a universal truth that 
'pathnames' are a far more fitting abstraction to any 'human based security 
process' on Linux than 'labels'. (It does not matter at all that security 
research suggest that the most secure systems are label based and that there 
are some hard problems with pathname based approaches such as hardlinks, 
--bind mounts, etc.)

So here i see somewhat of a conceptual failure of SELinux that would be nice 
to see fixed: inherent hostility against pathname based approaches, just 
because they are technically less secure.

To me the relabeling performance problem and the fact that selinux labels are 
physically attached to the objects themselves is a potentially bigger 
'security problem' than the racy nature (and aliasing/ambiguity problems) of 
VFS pathname based security is.

In other words: i see selinux's main failure in that it somewhat blindly aims 
for a security model that it sees as the technicaly most secure, while not 
being intellectually open to the fact that we very likely _cannot know in 
advance_ which of the models will make Linux more secure in the long run.

For example did you consider the possibility that the road towards a label 
based approach may as well be most practical _over_ a proxy step that used 
pathname based security? (i.e. once there's a critical mass of pathname based 
security policies, and there's distros/developers/users who maintain it, a 
much smaller step towards labels could be attempted - possibly automated to a 
certain degree.)

We cannot know how it will end up looking like in a few years because security 
is one of the few areas where computer technology mixes so strongly with 
psychology, and a secure system of this human scale was never attempted 
before. Prior security research is thus largely irrelevant. This also means 
that paradoxically, this intellectual inflexibility over the basic security 
model may as well make Linux less secure.

Also, why was/(is?) AppArmor considered as a 'hostile competitor' - instead of 
treating it more like a natural ally: another mechanism that allows us to 
_expand_ the total pool of per app security policies (and, more importantly, 
the pool of developers who care about those policies)?

Thanks,

	Ingo
