Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXJ3FNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXJ3FNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXJ3FNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:13:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:28090 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbXJ3FN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mwwTQO0CmB7uGw3bTJB7GaAsskVgk3ToXcFCphJyzDDZab4r7mP8HttDQH+EF8sxI5TLHwSAMdVJgs8uftRnLi1UBOwhH+JuUX46TYi19W10n+a59jXNFUnTTGZyRdsDNB+/MUP9y0NzmZyApRjFwRUEjLMz73GYuSaHpI/078E=
Message-ID: <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
Date: Tue, 30 Oct 2007 15:13:27 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
In-Reply-To: <4726377A.4080807@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>
	 <4726377A.4080807@crispincowan.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Crispin Cowan <crispin@crispincowan.com> wrote:
> Ah! So the proposal really is to have an LSM maintainer for each
> "family" of models, acting as a resource and arbiter for modules in a class.

I see it a little bit different one LSM maintainer for the lot of
modules who kicks the ass's of thoses who are not prepaid to share.
>
> I like that idea, and have no objection to it. However, it does have
> resource problems, in that the pool of LSM maintainers is not that
> large. There is also the likely objection that this degree of scale is
> not needed until at least there are multiple families of models in the
> upstream kernel, and possibly until there are multiple instances of a
> single family in the upstream kernel.
>
> It also begs the question of what constitutes a family.
>
>     * AppArmor, SELinux, and TOMOYO are all ambient capability systems
>           o AppArmor and TOMOYO are pathname based
>           o SELinux is label based

Here as always all three should see where they can share code and get
the best performance this might mean AppArmor and Tomoyo use Selinux
labels because it causes less overhead.  Or Selinux provides a
optional path based using the other engine.  Both are providing the
same feature in different ways.   Question does have to be asked is
there bench testable justification for need two for file systems
filters.

>     * SELinux and SMACK are label-based
>           o I don't know if SMACK is an ambient capability system

Both of these are sharing backwards and forwards between each other so
being nice with each other.  LSM overall Maintainer only really need
to at worst way xyz sections are not merged/shared and to document why
with benchmarks if they are not going to be.  Ie tested reason.

>     * Rob Meijer implicitly advocated for an object capability LSM
>           o would it be pathname or label based? You could do either or
>             both ...
Both is a valid answer.   Sections done path based should be shared
with other path based and labal based shared with other label based.

>     * The LSPP work from RH, Tresys, and TCS is MLS based
>           o this is a subset of both label-based and ambient capability
>             based
Ok section by section where would it be best for that code base to share with.

>     * I have no clue what family to put MultiADM or Dazuko into
MultiADMIN falls under o my god head ache.  This is more a posix
standard feature altered ie 1 root user turned into many.  This really
risks breaking the other models as a LSM.  Its more of a all in or all
out.  Really it needs to be lowered out of LSM into a standard
optional Linux feature so it cannot breach the security of other LSM
modules.  Also LSM modules will need to be made able to tell a
MultiADMIN root users.  This is part of what I was talking about some
parts need to be as lower down module not at full blown LSM level.
This is the rare one where the complete model needs to be moved down.
There are bits in almost all LSM that need to be looked at being made
full time features of linux like quotas and posix file capability's .

Dazuko is the rare user mode controlled interface.  Still same rule
share code where able.  Anti-Virus integration and other protecting
systems are commonly overlooked by LSM's.    Same here if this should
be a LSM or a kernel optional feature independent to LSM that a LSM
can block from happening.

>     * Getting very formal, I could imagine a Clarke-Wilson module
>     * Getting very informal, I could imagine a module that is a
>       collection of cute intrusion prevention hacks, such as the Open
>       wall Linux symlink and hardlink restrictions, and my own RaceGuard
>       work
>           o Oh wait, I published
>             <http://citeseer.ist.psu.edu/cowan01raceguard.html>
>             RaceGuard. Does that make it formal? :-)
>
You will hate me but I don't call that formal enough.  Its lacks the
critical bit of doc written in terms that any system admin can
understand what they are being given.

Next question should RaceGuard be a LSM at all.  Or should it be a
standard feature what LSM can over rule? <Swap RaceGuard out standard
question for all new LSM's and LSM features>

Lot of things are being pushed as LSM's when they should be pushed as
expanded default features outside LSM.

Peter Dolding
