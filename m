Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZCTE0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZCTE0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 00:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZCTE0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 00:26:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:38835 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZCTE0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 00:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p/omwd47YXXvfowWB9viONFZpRjeH6HsiR78Zp+8SCM1PMgmrz2QTiEttO4VqkoG/O
         fmGA4Y1F0py4hQEbzzBUO8ZT0JfzhqnT+4XOhgBRXrLszNlcCnZrIGIKQ2Zyct/iaTuu
         sglM7ZpfQ9PbjYowG7wp960MAa+BaPVdu5ow8=
MIME-Version: 1.0
In-Reply-To: <20090318183232.GA11594@kroah.com>
References: <20090318183232.GA11594@kroah.com>
Date: Fri, 20 Mar 2009 14:26:10 +1000
Message-ID: <21d7e9970903192126r69687891madbce3d5ee77f6a0@mail.gmail.com>
Subject: Re: The Linux Staging tree, what it is and is not.
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 4:32 AM, Greg KH <greg@kroah.com> wrote:
> Hi all,
>
> It's been many months since the Linux Kernel developers conference, where the
> linux-staging tree was discussed and role changed.  It turns out that people
> are still a bit confused as to what the staging tree is for, and how it works.
>
> So here's a short summary, I'm not going into the history or background here,
> that's a much longer writeup that I'd be glad to do if people are interested.
>
>
> The Linux Staging Tree, what it is and is not.
>
> What the Linux Staging tree is:
>  The Linux Staging tree (or just "staging" from now on) is used to hold
>  stand-alone[1] drivers and filesystems that are not ready to be merged into
>  the main portion of the Linux kernel tree at this point in time for various
>  technical reasons.  It is contained within the main Linux kernel tree so
>  that users can get access to the drivers much easier than before, and to
>  provide a common place for the development to happen, resolving the
>  "hundreds of different download sites" problem that most out-of-tree drivers
>  have had in the past.
>
> What the Linux Staging tree is not:
>  The staging tree is not a place to dump code and run away, hoping that
>  someone else will to the cleanup work for you.  While there are developers
>  available and willing to do this kind of work, you need to get them to agree
>  to "babysit" the code in order for it to be accepted.
>
> Location and Development:
>  The staging tree is now contained within the main Linux kernel source tree
>  at the location drivers/staging/.  All development happens within the main
>  kernel source tree, like any other subsystem within the kernel.  This means:
>        - the linux-next tree contains the latest version of the staging tree,
>          with bugfixes that are about to be merged into Linus's tree, as well
>          as the patches that are to be merged into the next major kernel
>          release.
>        - if you wish to do work on the staging tree, checkout the linux-next
>          tree and send patches based on that.
>
> Runtime:
>  When code from the staging tree is loaded in the kernel, a warning message
>  will be printed to the kernel log saying:
>    MODULE_NAME: module is from the staging directory, the quality is unknown, you have been warned.
>  and the kernel will be tainted with the TAINT_CRAP flag.  This flag shows up
>  in any kernel oops that might be produced after the driver has been loaded.
>
>  Note, most kernel developers have expressed the warning that they will not
>  work on bugs for when this taint flag has happened, so if you run into a
>  kernel problem after loading such a module, please work to reproduce the
>  issue without a staging module loaded in order to be able to get help from
>  the community.
>
> If anyone has any questions that this summary doesn't answer, please let me
> know.

What is the target audience for staging?

It doesn't fill the out-of-tree modules void as far as I can tell.

The model most users are stuck with are
a) distro kernel
b) hw not supported.

Distro kernel could be any revision from 2.6.15 or something crazy up until now.

Generally you can pull the out of tree modules zip file or repo, build
it against
the kernel you have installed and know works with all your other hw
and your nvidia
binary driver, and the out of tree people have wrapped all the API changes so
that you don't have to do much in theory for it to just build and
install on your
kernel.

Staging doesn't fulfill this role from my POV:
a) what sane distro will enable staging drivers? do they care about their users?
b) if your distro doesn't enable staging drivers you now have two options:
1. distro kernel rebuild with staging drivers enabled if new enough
distro kernel
2. kernel.org kernel build with staging drivers enabled.

For a normal user who just wants his hw to work, these options are possibly
most unappealing. They still want do just download something from out-of-tree
which does all the nice API break wrapping for them and is 1MB instead of 300MB.

So hence my target audience question.

Dave.
