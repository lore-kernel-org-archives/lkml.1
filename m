Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbXGVO4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbXGVO4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXGVO4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:56:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44768 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbXGVO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:56:38 -0400
Date: Sun, 22 Jul 2007 16:56:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722145636.GA31276@one.firstfloor.org>
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk> <20070722135814.GA32371@mail.linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722135814.GA32371@mail.linbit.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 03:58:14PM +0200, Lars Ellenberg wrote:
> On Sun, Jul 22, 2007 at 07:52:36AM +0200, Jens Axboe wrote:
> > On Sun, Jul 22 2007, Andi Kleen wrote:
> > > Lars Ellenberg <lars@linbit.com> writes:
> > > > 
> > > > Jens, Andrew, anyone: please review,
> > > > and give me advice how to proceed from here.
> > > 
> > > The standard procedure would be to post all the source code in logical
> > > pieces on the list for review. Then iterate until all comments are
> > > addressed.
> > 
> > Yep, cleanup the style issues (that make sense) from checkpatch and then
> > psot as a series of patches that can be reviewed. Linking to a git tree
> > wont get you very far.
> 
> it got me far enough, for the first try, anyways :-)
> I did not spam the lkml with patches, and still got some very useful
> advice (no idea how I could overlook the checkpatch.pl complaints).
> 
> If each patch of a series needs to compile and work,

That's not needed for review. The final submission can then be
in a single patch. It's just impossible to read a really large
single patch. Ideally you space the posting also out over time.to not
tax the review resources too much.

Another standard trick for compileable patch series is to only add the 
Kconfig at the end.

> 13 ERROR: no space between function name and open parenthesis '('
>     this is about our ERR_IF() macro...
>     suggestions, anyone?
>     do need I to explicitly write these out?

Preferable yes.

> 
>  8 ERROR: Macros with multiple statements should be enclosed in a do - while loop
>  1 ERROR: Macros with complex values should be enclosed in parenthesis
>     these are "netlink packet definition language" in drbd_nl.h,
>     which is sort of clean, and preprocessor magic in drbd_nl.c.
>     suggestions how to handle this cleanly,
>     without making it more ugly?
>     autogenerate code by other means?
>     write it out by hand, and lose the nice and clean drbd_nl.h?

No, you can ignore it then.

> 94 WARNING: declaring multiple variables together should be avoided
>     int snr, enr;
>     does this really need to become two lines?

Probably not.

> 
> 33 WARNING: line over 80 characters
>     hmmm. get more ugly...
>     probably need some helper functions and temp variables?

Yes smaller functions are better in general.

-Andi
