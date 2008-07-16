Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbYGPPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbYGPPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbYGPPpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:45:35 -0400
Received: from r00tworld.com ([212.85.137.21]:35203 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbYGPPpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:45:34 -0400
From: pageexec@freemail.hu
To: Theodore Tso <tytso@mit.edu>
Date: Wed, 16 Jul 2008 17:16:25 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Tiago Assumpcao <tiago@assumpcao.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487E2CE9.8301.1FE8B8D5@pageexec.freemail.hu>
In-reply-to: <20080716132112.GR8185@mit.edu>
References: <487D6AB9.7080700@schaufler-ca.com>, <487DDC78.2960.1EAE7F08@pageexec.freemail.hu>, <20080716132112.GR8185@mit.edu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 17:17:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 9:21, Theodore Tso wrote:

> On Wed, Jul 16, 2008 at 11:33:12AM +0200, pageexec@freemail.hu wrote:
> > not so quick. security is a big field, noone really can claim to be
> > a general expert. Ted knows kerberos but he would be unable to exploit
> > the task refcount leak bug fixed in 2.6.25.10. Stephen and you know
> > MAC systems inside out but you too would be unable to exploit that bug.
> > different domains, different expertise, despite all being 'security'.
> 
> As far as I am concerned, knowing how to exploit a task refcount leak
> bug is a technician's job.

you can try to downplay it like that, but it doesn't make it a simple
technician's job (go tell that to the NSA's red team members ;). exploit
development is an art, it's an expertise that you can't acquire in formal
education for example. that holds for many other aspects of computer
security in fact, that's why it's not an engineering discipline in any
sense that civil or mechanical engineering is. let's wait a few more
decades or centuries, and it will probably become one, but not today.

the reason i mentioned exploit development is actually that if you are
not aware of how you can exploit a bug, you're likely to make a bad
judgement call when you have to decide a bug's exploitability. *that*
will have bad effects on everyone else depending on your judgement.

>  Sure, I can write code that given an
> intercepted or stolen Kerberos srvtab/ketab file, how to forge
> Kerberos tickets.  But at the end of the day, that's perhaps the least
> important part of what a "Security Expert" has to do.  Bruce Schneier
> has written about this extensively.

what is important depends on the situation. for a pentester it's quite
important to be able to write exploits for example.
 
> The important thing to recognize about security is that it is all
> about tradeoffs.  How do you protect the System (which may consist of
> one computers or multiple computers) given a particular threat
> environment, given adversaries with different levels of capability,
> given the consequences of a security breach, and how do you do it
> within a given parameters of cost and usability?  

we have a simpler description for the purpose of security: it's all
about risk management. risk management is indeed about making decisions
that often involve tradeoffs. the responsibility of kernel developers
is, or should be, if it isn't, to help such decisions by not covering
up security fixes.

> This is why there are so many arguments over security.  There are
> disagreements over what deserves more focus and attention, and what is
> and isn't worthwhile trading off against other things.  For example,
> last I looked, PaX significantly reduces the chance of buffer overrun
> attacks, but at the cost of cutting your address space in half and
> forcing you to use a custom-built kernels since modules are not
> supported either (which means no tools like Systemtap, as well).  For
> some people, particularly on 32-bit systems, this is unacceptable.
> But some people might consider that a valid tradeoff.

actually, if we're talking 2.6, that's not true anymore, PaX will use
the hw NX bit if present, else it will fall back to the segmentation
based method. also, there's been module support for years now, in fact
it's better than that of vanilla in that i added proper separation of
rx/rw mappings for modules.

> As another example, take for example some bug that might be able to
> cause a local privilege escalation.  If the machine running that
> particular kernel is part of a computing cluster which is totally
> disconnected from the Internet, that bug is from a security point of
> view totally irrelevant.

not necessarily, it depends on who has local access to that cluster
and whether they separate privileges or not. say, if the admin/user
roles are separate, then it's very much relevant there as well. sure,
the threat model is different, but it doesn't mean it's non-existent.

> So to do a true security analysis about the seriousness of a bug
> *always* requires some amount of context about what the capabilities
> that the adversary might have (or might have acquired).  Given that
> most systems these days are single user systems, a local privilege
> escalation attack may not be as big a of deal in this day and age.
> Many people draw their trust boundary around the entire computer.

in fact, in this day and age of client side bugs (think browsers, media
players, etc), it is even more relevant. not because as if acquiring
normal user privileges didn't already break the given user's security,
but because by elevating to root, an attacker reduces his risk of being
discovered, not to mention gaining access to both the wife's and the
husband's emails at once. FWIW, i'm told that there's windows malware
that uses 0-day for both browser exploitation and local privilege
escalation, there's no reason to believe that the same cannot occur
on linux or elsewhere.

> At the end of the day, it is an engineering discipline, and it is all
> about tradeoffs.  So while it is useful to have people who focus on
> the security of a single box against adversaries who have local shell
> access, it is very easy to lose perspective of the greater security
> picture.

i'm not sure if you're thinking of me as who's losing focus, but let
me tell you why you can't just so easily separate local from remote
bugs. in this age of networks, we do not simply have computer networks,
we also have trust networks. if you have a shell account at mit.edu,
then someone elevating to root there will be able to trigger a client
side ssh bug on your personal box (just an example, don't go looking
for one). in other words, locally exploitable bugs != single box
security.

> I have a theory which is that people who are focused on local system
> security to the exclusion of all else have a high risk of becoming
> unbalanced;

why does asking kernel developers to describe security fixes as such
risk becoming unbalanced?

cheers,
  PaX Team

