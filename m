Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYGaGXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYGaGXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYGaGX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:23:29 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31432 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGaGX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:23:28 -0400
Date: Thu, 31 Jul 2008 00:23:05 -0600
From: Alex Chiang <achiang@hp.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
Message-ID: <20080731062305.GA18070@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Amanda McPherson <amanda@amcpherson.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080729143015.0f79cf37@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729143015.0f79cf37@bike.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jonathan Corbet <corbet@lwn.net>:
> For a little while now I've been working on an introductory document for
> developers and their employers; it's supposed to be a gentle introduction to
> the kernel development process.  Here it is in its rather long-winded
> entirety.  I'm interested in comments and ways to make it better -
> especially in places where I've said something especially stupid or missed
> an important point.  I'm sure there must be plenty of both...

Overall, a great document, as expected from you. I've replied with
"content" comments below.

I've a few ideas on "style" comments as well, on ways to maybe
tighten up the text a bit (too much Strunk & White in my past, I
suppose) without changing your style and tone too much.

But it occurs to me that sending "style" comments to the editor of
LWN is something akin to, well, some combination of Prometheus,
Icarus, ravenous vultures, rabid penguins, and telling Linus that
his choice of $EDITOR sucks, which is to say, "unwise".

On the other hand, if you are interested, let me know, and I can
make another pass at this with stylistic suggestions.

cheers,

/ac



> +2.1: THE BIG PICTURE
[...]
> +Once a stable release is made, its ongoing maintenance is passed of to the
                                                                    ^^
								    "off"


> +2.6: MAILING LISTS
[...]
> +- When responding to linux-kernel email (or that on other lists) preserve
> +  the Cc: header for all involved.  In the absence of a strong reason (such
> +  as an explicit request), you should never remove recipients.  Always make
> +  sure that the person you are responding to is in the Cc: list.

How about, "Do not ask to be Cc'd on the reply 'because you are not a list
subscriber'."? The previous convention ensures that you _will_ be cc'ed on
any responses.

> +Andrew Morton gives this advice for aspiring kernel developers
> +
> +       The #1 project for all kernel beginners should surely be "make sure
> +       that the kernel runs perfectly at all times on all machines which
> +       you can lay your hands on".  Usually the way to do this is to work
> +       with others on getting things fixed up (this can require
> +       persistence!) but that's fine - it's a part of kernel development.
> +
> +(http://lwn.net/Articles/283982/).

You've got url reference for some quotes but not all. Would it be possible to
track them all down? Sorry for asking for all the extra work, but I think
the references are useful, especially if the motivated reader actually
visits said reference and gets all sides of the story.


> +3.2: EARLY DISCUSSION
[...]
> + - The Reiser4 filesystem included a number of capabilities which, in the
> +   core developers' opinion, should have been implemented in the virtual
      ^^^^^^^^^^^^^^^^
This is slightly ambiguous. Should probably that clarify the existing kernel
core developers disagreed with the Reiser4 developers.


> +3.3: WHO DO YOU TALK TO?
[...]
> +Finding maintainers can be a bit harder.  Again, the MAINTAINERS file is
> +the place to start.  That file tends to not always be up to date, though,
> +and not all subsystems are represented there.  The person listed in the
> +MAINTAINERS file may, in fact, not be the person who is actually acting in
> +that role currently.  So, when there is doubt about who to contact, a
> +useful trick is to use git (and "git log" in particular) to see who is
> +currently active within the subsystem of interest.  Look at who is writing
> +patches, and who, if anybody, is attaching Signed-off-by lines to those
> +patches.  Those are the people who be best placed to help with a new
> +development project.

Well, this *almost* describes the trick, but for our imagined newbie
audience without any familiarity with git, is probably still confusing. ;)

How about adding an example...

	[...] is attaching Signed-off-by lines to those patches.  For
	example, 'git log drivers/pci' will show the history of the
	PCI subsystem.  The recurring Signed-off-by line on each patch
	should give a clue as to the current PCI maintainer.


> +4.1: PITFALLS
[...]
> +The other trap is to assume that code which is already in the kernel is
> +urgently in need of coding style fixes.  Developers may start to generate
> +reformatting patches as a way of gaining familiarity with the process, or
> +as a way of getting their name into the kernel changelogs - or both.  But
> +pure coding style fixes are seen as noise by the development community;
> +they tend to get a chilly reception.  So this type of patch is best
> +avoided.  It is natural to fix the style of a piece of code while working
> +on it for other reasons, but coding style changes should not be made for
> +their own sake.

If you're going to mention the naturally occurring code cleanups, it might
make sense to note that the cleanups should be separated out in a separate
patch, to make reviewing the changed logic of the new code easier.

> +
> +The coding style document also should not be read as an absolute law which
> +can never be transgressed.  If there is a good reason to go against the
> +style (a line which becomes far less readable if split to fit within the
> +80-column limit, for example), just do it.

How about a better example, such as user-visible printk strings should
not be broken at the 80-column limit, which improves greppability.

> +Abstraction layers
> +
> +Computer Science professors teach students to make extensive use of
> +abstraction layers in the name of flexibility and information hiding.
> +Certainly the kernel makes extensive use of abstraction; no project
> +involving several million lines of code could do otherwise and survive.
> +But experience has shown that excessive or premature abstraction can be
> +just as harmful as premature optimization.  Abstraction should be used to
> +the level required and no further.
> +
> +At a simple level, consider a function which has an argument which is
> +always passed as zero by all callers.  One could retain that argument just
> +in case somebody eventually needs to use the extra flexibility that it
> +provides.  By that time, though, chances are good that the code which
> +implements this extra argument has been broken in some subtle way which was
> +never noticed - because it has never been used.  Or, when the need for
> +extra flexibility arises, it does not do so in a way which matches the
> +programmer's early expectation.  Kernel developers will routinely submit
> +patches to remove unused arguments; they should, in general, not be added
> +in the first place.

Hm, I thought this section was going to talk about foo_t and the like,
as described in CodingStyle. Agreed, extraneous function args are bad,
but they don't seem like a "premature abstraction" problem to me.

Just a thought.


> +4.2: CODE CHECKING TOOLS
[...]
> +Other kinds of errors can be found with the "sparse" static analysis tool.
> +With sparse, the programmer can be warned about confusion between
> +user-space and kernel-space addresses, mixture of big-endian and
> +small-endian quantities, the passing of integer values where a set of bit
> +flags is expected, and so on.  Sparse must be installed separately (it can
> +be found at http://www.kernel.org/pub/software/devel/sparse/ if your
> +distributor does not package it); it can then be run on the code using the
> +C=1 flag to make.

That might read better as, "run on the code passing the C=1 flag to make."

> +
> +Other kinds of portability errors are best found by compiling your code for
> +other architectures.  If you do not happen to have an S/390 system or a
> +Blackfin development board handy, you can still perform the compilation
> +step.  A full set of cross compilers for x86 systems can be found at 
> +
> +	http://www.kernel.org/pub/tools/crosstool/

Hm, "full set" is debatable. I don't see pa-risc, for example. ;)

> +4.3: DOCUMENTATION
[...]
> +Internal API information for many subsystems is documented by way of
> +specially-formatted comments; these comments can be extracted and formatted
> +in a number of ways by the "kernel-doc" script.  If you are working within
> +a subsystem which has kerneldoc comments, you should maintain them and add
> +them, as appropriate, for externally-available functions.  Even in areas
> +which have not been so documented, there is no harm in adding kerneldoc
> +comments for the future.  The format of these comments, along with some

It might be noted that adding kerneldoc for undocumented functions *is*
a great way for newbies to participate and ramp up in a quite-welcome way,
as opposed to whitespace/coding style patches.


> +5.3: PATCH PREPARATION
[...]
> +Patches must be prepared against a specific version of the kernel.  As a
> +general rule, a patch should be based on the current mainline as found in
> +Linus's git tree.  It may become necessary to make versions against -mm,
   ^^^^^^^
Hm, is this the new recommended style? Grammar school taught me that it
should be "Linus'" but I've noticed a gradually changing but inconsistently
applied new school style.

Just curious.


> +5.5: SENDING THE PATCH
[...]
> +If you have a significant series of patches, it is customary to send an
> +introductory description as part zero.  In general, the second and

This directly conflicts with akpm's advice:

	http://www.zipworld.com.au/~akpm/linux/patches/stuff/tpp.txt

Section 6(b).

Who wins? :)

