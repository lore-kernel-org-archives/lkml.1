Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXJVRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXJVRBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJVRBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:01:08 -0400
Received: from ruby.spiritone.com ([216.99.193.130]:58041 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXJVRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:01:07 -0400
Date: Mon, 22 Oct 2007 10:00:46 -0700
Message-Id: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
From: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       LSM ML <linux-security-module@vger.kernel.org>,
       Crispin Cowan <crispin@crispincowan.com>
Reply-To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Subject: Re: LSM conversion to static interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some well-respected contributors have taken exception my amplification
of Crispin Cowan's point about the patch that closes LSM.

Crispin Cowan <crispin@crispincowan.com> wrote:
>     * It prevents enterprise users, and in fact anyone who isn't
>       comfortable compiling their own kernel, from ever trying out any
>       security module that their distro vendor of choice did not ship.

I extended this point by observing that regulatory laws make it difficult
for enterprise customers to compile their own kernels, mentioning one
of the more invasive statutes, Sarbanes-Oxley.

In reply, "Alan Cox" <alan@lxorguk.ukuu.org.uk> writes:
> Crispin at least is providing genuine discussion points. Sarbox has
> nothing to say on "using vendor linux kernels".

And just previously, "Greg KH" <greg@kroah.com> had written:
> Since when does Sarbanes-Oxley decree that a company must use a
> "standard kernel"?  And just exactly what defines such "standard
> kernel"?  Can you point out where in that bill it requires such a
> thing?

I was actually talking about the *effects* of regulatory law, rather
than the wording in the text of the statutes.  The misunderstanding
could be partially my fault, as my exact words were 

   As Sarbanes-Oxley and other regulatory laws require these
   customers to use "standard kernels" ....

which may not have been as unambiguously clear as I intended.

But as long as we're here, let me elaborate on the point I tried to make.

SOX and other laws require enterprise customers to keep specified
controls on their internal processing procedures, and keep documentation
that can be audited to prove compliance.  The auditing requirements
are extensive and detailed, and certainly include the kernel of an
operating system used to process business and/or financial transactions.

It is within this framework that enterprise customers conclude something
like (and this is vernacular, not the language within the statutes) "if
we use any kernel other than that supplied by our distributor, the
SOX auditing paperwork will be a nightmare."  (I've actually heard
statements similar to this, and so believe that it is an accurate
portrayal of the perception of the effects of regulatory law.  I'm not
a lawyer.)

As I said at the beginning, I meant to amplify Crispin's observation
that enterprise customers are reluctant to compile their own kernels
with the additional observation that the complexities of regulatory
law create obstacles that are significant contributors to that reluctance.

I'll not belabor the unfortunate non sequitur further.  You can find
plenty of documentation of auditing requirements with by Googling
combinations of "Sarbanes-Oxley," "operating system integrity", etc.
This is a big-business topic of wide concern.

 =========

So where were we before that detour?  Oh yes, 

The point of contention:  closing LSM significantly reduces the freedom
of an important class of Linux users, the commercial enterprises, to
use whatever security framework they desire.  Greg and Alan didn't
address this, and neither has anyone else.  Crispin's concluding remark
on the patch closing LSM to modules has also not been addressed:

> So I don't think I am being self-serving in arguing against this
> patch. I just think it is bad for Linux.

Yes.  Why indeed should Linux, justly famous for being configurable
to many disparate purposes, close down an important subsystem so that
only a few types of security frameworks are possible?

Why can't a CONFIG_ system be developed that can give everyone pretty
much what he wants?  It should be possible to develop a system
permitting much flexibility wrt security frameworks:
 1.  a kernel configured with statically-linked hooks into exactly
      one framework.
                     --- OR ---
 2.  a kernel configured with an in-tree framework, but which uses
      an LSM "security_operations" table.  (This is what we pretty much
      have in 2.6.23).  In addition, a new boot parameter could let the
      end user name the framework to use, which would completely
      replace the in-tree default framework at boot time.


To possibly save bandwidth, I'll also respond to another of Greg's points:

"Greg KH" <greg@kroah.com> wrote:
> Any "customer" using a security model other than provided by their Linux
> distributor instantly voided all support from that distro by doing that.

This isn't necessarily true.  In fact, I don't think it's even _remotely_
likely to be typical.

Security is big business, as is compliance with regulatory law.  Large
enterprise customers are NOT going to either void their system support
contracts, or place themselves in jeopardy of failing a SOX audit.
Much more likely would be negotiated collaboration between some Linux
distributors and security software firms that will permit enterprise
customers to purchase, in a bundle, the security software products
they require, along with the documentation needed to prove compliance
with regulatory law.

At least, this seems to be what the market demands, or is beginning to
demand.  Will there be a supply?  Probably, as there is money ready to buy
it.  Can closure of the LSM stop it?  Probably not, but I think that closing
LSM to out-of-tree security modules substantially reduces the viability
of Linux technology, as it fails to address the the needs of an important
class of Linux user, the commercial enterprises.  As I said previously,
I think it will irritate them quite a lot.

Is this really a good idea?  Why is it a good idea to strip important
freedoms from _any_ end user?  Much less a whole class of commercially
important end users?

Furthermore, I don't think it's **necessary** to do an absolute closure in
order to meet the stringent needs of those who demand a single, hard-wired
security framework, such as has been proposed by James Morris.  The KBuild
system seems aptly suited to address the different needs of different users.

 ==========

This just in.  On the issue of making LSM much less available (please
forgive me if I've inaccurately summarized), Crispin just now wrote:

> That is not a catastrophe, it is just tedious. It does not kill baby
> seals, and it does not make Linux utterly useless. OTOH, I think it is
> strictly negative: it takes away user choice in 2 dimensions, and adds
> zero value. So apply it if you must to bake the kernel developer's lives
> easier, but it really is a net loss in Linux kernel capability.

I think that's a pretty good formulation of my points:  user choice is
taken away, leaving a net loss in the capability of Linux, and that
it's not at all necessary.

In the same note, he agreed with Alan that "SarBox is not really the issue
here."  Well, I'm pretty certain that regulatory law strongly shapes
market forces and enterprise needs.  In particular, I've heard several
times that enterprises users  really want to just BUY all their security
products, and that these products must be accompanied by documentation for
any audits.  So, I'm pretty sure that if it is "not ... the issue", it
strongly influences the issue.

Thanks for your consideration,

Tommy F.

