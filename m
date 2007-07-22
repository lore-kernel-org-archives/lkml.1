Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXGVPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXGVPud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbXGVPuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:50:11 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:14566 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbXGVPuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f3FgdBlW9B14L1qKHoC8E+cCa6j8gzp1qA6nPpFzHZGU4mOa0SwDev8mCyLp9y96k0Yc5P0PLu9Df5FkC/CwnyGeLXL+DEU4z7MwEdP72xUBMs9ofz2VyUd6imtQWYiHPprlH4cKFtu3sKgEtBgedydKFFXE59BCAn7YZcyJWBU=
Message-ID: <a781481a0707220850q4d1a176ds350819637b46e54d@mail.gmail.com>
Date: Sun, 22 Jul 2007 21:20:06 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Lars Ellenberg" <lars.ellenberg@linbit.com>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707220831y67bcd64k34d52c3150c27dc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721203819.GA10706@mail.linbit.com>
	 <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk>
	 <20070722135814.GA32371@mail.linbit.com>
	 <a781481a0707220831y67bcd64k34d52c3150c27dc1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/22/07, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> [...]
> >  8 ERROR: Macros with multiple statements should be enclosed in a do - while loop
>
> You don't want to break if-else constructs.
>
> >  1 ERROR: Macros with complex values should be enclosed in parenthesis
>
> I'm not sure know when / why checkpatch.pl reports this. I don't want to
> pull your tree so can't check for myself, but note some obvious rules:
>
> 1. Macro definition must always include parenthesis around the entire
> definition (unless it's a do { somehting; } while (0) kind of macro).
> 2. Use parenthesis around wherever it uses the passed argument(s).
>
> >     these are "netlink packet definition language" in drbd_nl.h,
> >     which is sort of clean, and preprocessor magic in drbd_nl.c.
> >     suggestions how to handle this cleanly,
> >     without making it more ugly?
> >     autogenerate code by other means?
> >     write it out by hand, and lose the nice and clean drbd_nl.h?
>
> 1. Open-code it if it is trivial enough and there's no point
> obfuscating anything.
> 2. Consider making the macro a function. Probably inline, most probably not.
> 3. Macros must NOT evaluate the passed argument twice -- consider the
> possible damages of someone who doesn't know it's a macro and therefore
> passing in an expression that has side-effects (*boom, crash*).


Some more macro tips for you:

If the macro contains multiple statements but must also return a value
to the caller (i.e. say it can appear on RHS of an assignment), use the:

#define foo ({ something; lastthing; })

kind of idiom. So the return value of the last statement ("lastthing;"
above) in there (obviously) becomes the return value of the whole
macro. So if you need to define an internal variable inside the macro,
and the return value of the macro should be that internal variable itself,
use the:
#define bar ({ int __mvar; __mvar = something; otherstuff; __mvar; })
kind of idiom.

Of course, if you really try to pull off the above stunts, we'll probably
ask you to go back and make that a proper function in the first place :-)
