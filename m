Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbXKDPzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbXKDPzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 10:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXKDPzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 10:55:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:48127 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXKDPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 10:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GISeSuorNyvXXpzPvTZT3HwPhddvFqyFt6+jVBh6tX78omtTJFoQ2eRT7u83yQqHot/DNPE1rYRlzRvNioWVgX1s6mkCaNwgiPY7sLCcDzS7g+W9LqzQaVhKGGnWwtsscfnOGLsPNrmSCSX9oyvtnH9xMrRk4Gi8L1PgdT2flTI=
Message-ID: <8499950a0711040755g4360fe1ew25086642de160b19@mail.gmail.com>
Date: Sun, 4 Nov 2007 16:55:30 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu, sam@ravnborg.org,
       thomas@archlinux.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071104152930.GL12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071103121149.GA22149@uranus.ravnborg.org>
	 <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu>
	 <20071104.023133.241080055.davem@davemloft.net>
	 <20071104152930.GL12045@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

= 11/4/07 =

> > > > I also have CFLAGS set on some computers in my environments since for
> > > > packages using GNU autoconf that's the correct way to set the compiler
> > > > flags.
[]
> >  ...
> > > At minimum the extra CFLAGS needs to be put into the .config - but
> > > that's not a too nice solution either.

A y/n config option to pull flags from the env?

> > > How about just adding an extra-CFLAGS option to .config and perhaps
> > > a 'make configpickupCFLAGS' pass for anyone who wants to propagate
> > > the environment CFLAGS into the kernel build.
> >
> > I totally disagree.

I do too. Every ordinary (like shell, i.e. which is not setting own env
program) exec*() will copy that mostly useless var for every subshell,
`cat`, `cp`, `mv`...

[]
> > Do you even understand that taking this out of kbuild will just push
> > the problem one level of indirection away?  Say this stupid CFLAGS
> > setting creaps into someone's gcc bootstrap, and that gcc miscompiles
> > the kernel.  You will have fun debugging that too, but I'm sad to say
> > you won't be able to pass the blame to kbuild on that one 8-/
> >
> > It's just more proof that setting CFLAGS globally in your environment
> > is just plain stupid and asking for trouble.
> >
> > Don't do it.
>
> I'm not seeing what's stupid about this.
[]
-- 
-o--=O`C
 #oo'L O
<___=E M
