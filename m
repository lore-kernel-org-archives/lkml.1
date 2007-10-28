Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXJ1X4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXJ1X4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXJ1X4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:56:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:46560 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXJ1Xz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DFbtrQEqvvytw2aeLlp9kwEjtfTQXA8sURROUqZJBOwmXlPAg/jgRqHOS/Uy4ISi8JzneZsZWbACFwNisWuerzJhE5S3J+DAK1sYL2Ws2KnBoKmeq2cLCRFS5jlqiVwoPpEoer4/TnYyxWSR6lcX07mlihQpUDuF31Ra+4xYI7g=
Message-ID: <e7d8f83e0710281655y5818b3a8o247d0c7b1ddb657@mail.gmail.com>
Date: Mon, 29 Oct 2007 09:55:47 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <47250878.6040506@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	 <20071025024131.6082e4a8@the-village.bc.nu>
	 <47250878.6040506@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Crispin Cowan <crispin@crispincowan.com> wrote:
> To reject an LSM for providing "bad" security, IMHO you should have to
> show how it is possible to subvert the self-stated goals of that LSM.
> Complaints that the LSM fails to meet some goal outside of its stated
> purpose is irrelevant. Conjecture that it probably can be violated
> because of $contrivance is just so much FUD.

LSM is providing bad security on two fronts.

Number 1 LSM are speeding effort to create features.  Apparmor and
Selinux both provide file access filtering from applications.  Yet
they double up the code to do it.   So they cannot be used with each
other without doubling up hooks.  Then other LSM are creating there
own sections of code to do the same thing.   Simple rule more code
more risk of bugs since it will be less audited.  Duplication defense
features is really bad for security.  Some how code sharing has to be
got into LSM construction.

Number 2 The critical bit LSM stop at the edges of applications.   Now
without overlapping my hooks with existing LSMs I cannot create
application level protections.  Overlapping hooks will cause speed
loss.

LSM is set to protect the application. But inside the application
there will be sections that need the access rights and others that
don't.  Now a exploit in any section of the application under LSM gets
the LSM assigned rights.   With application level this can be done a
few ways extension to elf that is create by the complier and api calls
lowering access functions of current thread or for a starting thread.
If you exploit a section of the code without access to disk network
access and so on and without the right to call any function that does
that.   What have you exploited.   Minor data damage compared to
complete data that the application have access to being stolen as what
is the case with LSM at moment.  Basically LSM prevent taking control
of the complete system but don't help to stop peoples private data
from being stolen.  Both are bad to happen to a person.

LSM design is there to help security development not get in its way or
to cause bitrot.  Currently LSM design is causing major risk bitrot in
duplicated code.

Reading and processing configuration files should be independent to
the protection methods.   Hopefully designed to be able to run user
mode to test if the new profile for a application is safe to add
before adding it to the OS.   Typo prevention on both sides.  Current
method of just sticking everything into one huge blob is preventing
code sharing and risking more security holes.

The current LSM design is bad on so many levels.  I am surprised that
it takes a Non PHD System Admin to see it.  Some how I think its a
empire thing.   If everything was just simple blocks a person could
write a new LSM in hours with pretty good security.  Compared to
todays long time trying effort.  Leads of Apparmor selinux and so on
not being prepared to give up there little empire for the greater
good.

I personally hate stacking as a idea.  I personally prefer two layers
only.  Config reading and  enforcement.   Of course that does not stop
applications being assigned to different config reading systems.
Depth the two layers should stay fixed even if you have many different
models in use.

All LSM seam to want to force System Admins to pick there LSM over
another.   Instead of being able to pick LSM for task at hand.   Same
with poor security being better than no security its true.  Its
nothing strange to find selinux based systems with there security
disabled because the Admin cannot configure it.   But the reverse is
also true that when you have skilled Admins stuck with a system like
Apparmor cannot harden the system as far as they could with selinux.
Both ways its causing security holes poor security when you should
have good security is bad too.  Part of the problem LSM maintainers
are not at the front lines is all I can guess.  Because they don't
seam to know what is really needed.

Peter Dolding
