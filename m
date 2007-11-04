Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXKDKbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXKDKbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXKDKbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:31:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756147AbXKDKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:31:34 -0500
Date: Sun, 04 Nov 2007 02:31:33 -0800 (PST)
Message-Id: <20071104.023133.241080055.davem@davemloft.net>
To: mingo@elte.hu
Cc: bunk@kernel.org, sam@ravnborg.org, thomas@archlinux.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071104100429.GA12311@elte.hu>
References: <20071103121149.GA22149@uranus.ravnborg.org>
	<20071104020217.GJ12045@stusta.de>
	<20071104100429.GA12311@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 4 Nov 2007 11:04:29 +0100

> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > I also have CFLAGS set on some computers in my environments since for 
> > packages using GNU autoconf that's the correct way to set the compiler 
> > flags.
> > 
> > The kernel already sets all flags correctly, and a user wanting to 
> > change the flags for the kernel is an exception with very special 
> > needs (I'd even claim so special that he could simply edit the 
> > Makefile...).
 ...
> At minimum the extra CFLAGS needs to be put into the .config - but 
> that's not a too nice solution either. How about just adding an 
> extra-CFLAGS option to .config and perhaps a 'make configpickupCFLAGS' 
> pass for anyone who wants to propagate the environment CFLAGS into the 
> kernel build.

I totally disagree.

People can't have it both ways.  CFLAGS has global meaning in every
Makefile based build tree, it's not an "autoconf" thing.  This is well
established practice, and I think it's a good thing the kernel does it
now too.

If people set something like CFLAGS in their environment, they must
understand what that means, and it means that universally it will
influence your Makefile based builds.  Yes, this means all of them and
even potentially the kernel build.

I definitely think the new kbuild CFLAGS behavior is just fine.  I
would never ever set CFLAGS globally in my environment and expect sane
things to happen.

If people do stupid things in their environment without being willing
to accept all of the consequences, that isn't a reason to not provide
this feature in kbuild.

Do you even understand that taking this out of kbuild will just push
the problem one level of indirection away?  Say this stupid CFLAGS
setting creaps into someone's gcc bootstrap, and that gcc miscompiles
the kernel.  You will have fun debugging that too, but I'm sad to say
you won't be able to pass the blame to kbuild on that one 8-/

It's just more proof that setting CFLAGS globally in your environment
is just plain stupid and asking for trouble.

Don't do it.
