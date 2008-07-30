Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYG3HQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYG3HQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYG3HPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:15:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYG3HPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:15:51 -0400
Date: Wed, 30 Jul 2008 00:15:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>
Subject: Re: [PATCH, RFC] A development process document
Message-Id: <20080730001508.9095f571.akpm@linux-foundation.org>
In-Reply-To: <20080729143015.0f79cf37@bike.lwn.net>
References: <20080729143015.0f79cf37@bike.lwn.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 14:30:15 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> For a little while now I've been working on an introductory document for
> developers and their employers; it's supposed to be a gentle introduction
> to the kernel development process.  Here it is in its rather long-winded
> entirety.  I'm interested in comments and ways to make it better -
> especially in places where I've said something especially stupid or
> missed an important point.  I'm sure there must be plenty of both...
> 

Is good.  Thanks for doing this.  (pokes Greg)

I wonder a bit whether a ./Documentation update is the best way to
present this.  Rather than, say, http://www.kernel.org/read-this.html. 
The latter may be easier for you to update, and we won't have the
problem of people reading two-year-old versions of the document.

We can do both, I guess.  No strong opinions here.

>
> ...
>
> +The Linux kernel, at over 6 million lines of code and 2000 active
> +contributors,

I suspect the "2000 active developers" is a bit hypey.  Is a 0.5
patch/annum developer "active"?

>
> ...
>
> +1.2: THE IMPORTANCE OF GETTING CODE INTO THE MAINLINE
> +
> +Some companies and developers occasionally wonder why they should bother
> +learning how to work with the kernel community and get their code into the
> +mainline kernel (the "mainline" being the kernel maintained by Linus
> +Torvalds and used as a base by Linux distributors).  In the short term,
> +contributing code can look like an avoidable expense; it seems easier to
> +just keep the code separate and support users directly.  The truth of the
> +matter is that keeping code separate ("out of tree") is a false economy.
> +
> +As a way of illustrating the costs of out-of-tree code, here are a few
> +relevant aspects of the kernel development process; most of these will be
> +discussed in greater detail later in this document.  Consider:
> +
> +- Code which has been merged into the mainline kernel is available to all
> +  Linux users.  It will automatically be present on all distributions which
> +  enable it.  There is no need for driver disks, downloads, or the hassles
> +  of supporting multiple versions of multiple distributions; it all just
> +  works, for the developer and for the user.  Incorporation into the
> +  mainline solves a large number of distribution and support problems.
> +
> +- While kernel developers strive to maintain a stable interface to user
> +  space, the internal kernel API is in constant flux.  The lack of a stable
> +  internal interface is a deliberate design decision; it allows fundamental
> +  improvements to be made at any time and results in higher-quality code.
> +  But one result of that policy is that any out-of-tree code requires
> +  constant upkeep if it is to work with new kernels.  Maintaining
> +  out-of-tree code requires significant amounts of work just to keep that
> +  code working.
> +
> +  Code which is in the mainline, instead, does not require this work as the
> +  result of a simple rule requiring developers to fix any code which breaks
> +  as the result of an API change.  So code which has been merged into the
> +  mainline has significantly lower maintenance costs.
> +
> +- Beyond that, code which is in the kernel will often be improved by other
> +  developers.  Surprising results can come from empowering your user
> +  community and customers to improve your product.
> +
> +- Kernel code is subjected to review, both before and after merging into
> +  the mainline.  No matter how strong the original developer's skills are,
> +  this review process invariably finds ways in which the code can be
> +  improved.  Often review finds severe bugs and security problems.  This is
> +  especially true for code which has been developed in an closed
> +  environment; such code benefits strongly from review by outside
> +  developers.  Out-of-tree code is lower-quality code.
> +
> +- Participation in the development process is your way to influence the
> +  direction of kernel development.  Users who complain from the sidelines
> +  are heard, but active developers have a stronger voice - and the ability
> +  to implement changes which make the kernel work better for their needs.
> +
> +- Contribution of code is the fundamental action which makes the whole
> +  process work.  By contributing your code you can add new functionality to
> +  the kernel and provide capabilities and examples which are of use to
> +  other kernel developers.  If you have developed code for Linux (or are
> +  thinking about doing so), you clearly have an interest in the continued
> +  success of this platform; contributing code is one of the best ways to
> +  help ensure that success.

Also: if the code is kept out-of-tree then there is a risk that someone
else's similar feature will be merged in mainline.  So you end up
owning (and maintaining) a similar-but-different feature to something
which is already available.  Either that, or you need to migrate your
developers and/or users over to the new implementation, with all that
this entails.

otoh, if you merge your feature, it's the other guy who gets to cry
over the above paragraph.

>
> ...
>
> +There are a few hints which can help with linux-kernel survival:
> +
> +- Have the list delivered to a separate folder, rather than your main
> +  mailbox.  One must be able to ignore the stream for sustained periods of
> +  time.
> +
> +- Do not try to follow every conversation - nobody else does.  It is
> +  important to filter on both the topic of interest (though note that
> +  long-running conversations can drift away from the original subject
> +  without changing the email subject line) and the people who are
> +  participating.  
> +
> +- Do not feed the trolls.  If somebody is trying to stir up an angry
> +  response, ignore them.
> +
> +- When responding to linux-kernel email (or that on other lists) preserve
> +  the Cc: header for all involved.  In the absence of a strong reason (such
> +  as an explicit request), you should never remove recipients.  Always make
> +  sure that the person you are responding to is in the Cc: list.
> +
> +- Search the list archives (and the net as a whole) before asking
> +  questions.  Some developers can get impatient with people who clearly
> +  have not done their homework.
> +
> +- Ask on the correct mailing list.  Linux-kernel may be the general meeting
> +  point, but it is not the best place to find developers from all
> +  subsystems.

- don't top-post :(  It creates a rather poor impression.

> +The last point - finding the correct mailing list - is a common place for
> +beginning developers to go wrong.  Somebody who asks a networking-related
> +question on linux-kernel will almost certainly receive a polite suggestion
> +to ask on the netdev list instead, as that is the list frequented by most
> +networking developers.  Other lists exist for the SCSI, video4linux, IDE,
> +filesystem, etc. subsystems.  The best place to look for mailing lists is
> +in the MAINTAINERS file packaged with the kernel source.
> +
> +
> +2.7: GETTING STARTED WITH KERNEL DEVELOPMENT
> +
> +Questions about how to get started with the kernel development process are
> +common - from both individuals and companies.  Equally common are missteps
> +which make the beginning of the relationship harder than it has to be.
> +
> +Companies often look to hire well-known developers to get a development
> +group started.  This can, in fact, be an effective technique.  But it also
> +tends to be expensive and does not do much to grow the pool of experienced
> +kernel developers.  It is possible to bring in-house developers up to speed
> +on Linux kernel development, given the investment of a bit of time.  Taking
> +this time can endow an employer with a group of developers who understand
> +the kernel and the company both, and who can help to train others as well.
> +Over the medium term, this is often the more profitable approach.
> +
> +Individual developers are often, understandably, at a loss for a place to
> +start.  Beginning with a large project can be intimidating; one often wants
> +to test the waters with something smaller first.  This is the point where
> +some developers jump into the creation of patches fixing spelling errors or
> +minor coding style issues.  Unfortunately, such patches create a level of
> +noise which is distracting for the development community as a whole, so,
> +increasingly, they are looked down upon.  New developers wishing to
> +introduce themselves to the community will not get the sort of reception
> +they wish for by these means.
> +
> +Andrew Morton gives this advice for aspiring kernel developers
> +
> +       The #1 project for all kernel beginners should surely be "make sure
> +       that the kernel runs perfectly at all times on all machines which
> +       you can lay your hands on".  Usually the way to do this is to work
> +       with others on getting things fixed up (this can require
> +       persistence!) but that's fine - it's a part of kernel development.
> +
> +(http://lwn.net/Articles/283982/).

wise chap.

>
> ...
>
> +3.3: WHO DO YOU TALK TO?
> +
> +When developers decide to take their plans public, the next question will
> +be: where do we start?  The answer is to find the right mailing list(s) and
> +the right maintainer.  For mailing lists, the best approach is to look in
> +the MAINTAINERS file for a relevant place to post.  If there is a suitable
> +subsystem list, posting there is often preferable to posting on
> +linux-kernel; you are more likely to reach developers with expertise in the
> +relevant subsystem and the environment may be more supportive.
> +
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

I guess it's worth mentioning that if you can't find the right person,
or if the right person won't talk to you, try akpm@...

>
> ...
>
> +Other kinds of errors can be found with the "sparse" static analysis tool.
> +With sparse, the programmer can be warned about confusion between
> +user-space and kernel-space addresses, mixture of big-endian and
> +small-endian quantities, the passing of integer values where a set of bit
> +flags is expected, and so on.  Sparse must be installed separately (it can
> +be found at http://www.kernel.org/pub/software/devel/sparse/ if your
> +distributor does not package it); it can then be run on the code using the
> +C=1 flag to make.
> +
> +Other kinds of portability errors are best found by compiling your code for
> +other architectures.  If you do not happen to have an S/390 system or a
> +Blackfin development board handy, you can still perform the compilation
> +step.  A full set of cross compilers for x86 systems can be found at 
> +
> +	http://www.kernel.org/pub/tools/crosstool/
> +
> +Some time spent installing and using these compilers will help avoid
> +embarrassment later.

It might be worth mentioning Documentation/SubmitChecklist.  Although I
sometimes think we should translate it into Swahili and see how long it
takes for someone to notice.

> +
> +4.3: DOCUMENTATION

I think changelogging deserves its own section.  It's so important for
smooth progress, and is often done so poorly.

>
> ...
>
> +5: POSTING PATCHES
> +
> +Sooner or later, the time comes when your work is ready to be presented to
> +the community for review and, eventually, inclusion into the mainline
> +kernel.  Unsurprisingly, the kernel development community has evolved a set
> +of conventions and procedures which are used in the posting of patches;
> +following them will make life much easier for everybody involved.  This
> +document will attempt to cover these expectations in reasonable detail;
> +more information can also be found in the files SubmittingPatches,
> +SubmittingDrivers, and SubmitChecklist in the kernel documentation
> +directory.

ooh, there it is.

>
> ...
>
> +What all of this comes down to is that, when reviewers send you comments,
> +you need to pay attention to the technical observations that they are
> +making.  Do not let their form of expression or your own pride keep that
> +from happening.  When you get review comments on a patch, take the time to
> +understand what the reviewer is trying to say.  If possible, fix the things
> +that the reviewer is asking you to fix.  And respond back to the reviewer:
> +thank them, and describe how you will answer their questions.
> +
> +Note that you do not have to agree with every change suggested by
> +reviewers.  If you believe that the reviewer has misunderstood your code,
> +explain what is really going on.  If you have a technical objection to a
> +suggested change, describe it and justify your solution to the problem.  If
> +your explanations make sense, the reviewer will accept them.  Should your
> +explanation not prove persuasive, though, especially if others start to
> +agree with the reviewer, take some time to think things over again.  It can
> +be easy to become blinded by your own solution to a problem to the point
> +that you don't realize that something is fundamentally wrong or, perhaps,
> +you're not even solving the right problem.
> +
> +One fatal mistake is to ignore review comments in the hope that they will
> +go away.  They will not go away.  If you repost code without having
> +responded to the comments you got the time before, you're likely to find
> +that your patches go nowhere.

Yeah.

One quite dispiriting thing for a reviewer is to spend an hour reading
and commenting, and then to get a complete new version of the patchset
a week later with no accounting of the earlier review comments.  Plus
for the reviewer, that was hundreds of patches ago, so your patch has
been forgotten about.

I think there are two ways of addressing this

a) reply to the reviewer's reply, dispositively addressing each of the
   points individually, then send a new patch or

b) send an incremental patch, with all the changed things
   bullet-pointed in the changelog.

or both.

But the key point here is to not present the guy with a whole new patch
which he has to re-review from scratch, wondering what he's missed from
last time.

>
> ...
>
> +What may also happen at this point, depending on the nature of your patch,
> +is that conflicts with work being done by others turn up.  In the worst
> +case, heavy patch conflicts can result in some work being put on the back
> +burner so that the remaining patches can be worked into shape and merged.
> +Other times, conflict resolution will involve working with the other
> +developers and, possibly, moving some patches between trees to ensure that
> +everything applies cleanly.  This work can be a pain, but count your
> +blessings: before the advent of the linux-next tree, these conflicts often
> +only turned up during the merge window and had to be addressed in a hurry.
> +Now they can be resolved at leisure, before the merge window opens.
> +
> +Some day, if all goes well, you'll log on and see that your patch has been
> +merged into the mainline kernel.  Congratulations!  Once the celebration is
> +complete, though, it is worth remembering an important little fact: the job
> +still is not done.  Merging into the mainline brings its own challenges.

Don't forget to add yourself to ./MAINTAINERS.  And create a bugzilla
account.
