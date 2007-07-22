Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXGVN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXGVN6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGVN6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 09:58:17 -0400
Received: from aug.linbit.com ([212.69.162.22]:47038 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751322AbXGVN6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 09:58:16 -0400
Date: Sun, 22 Jul 2007 15:58:14 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722135814.GA32371@mail.linbit.com>
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de> <20070722055235.GQ11657@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722055235.GQ11657@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 07:52:36AM +0200, Jens Axboe wrote:
> On Sun, Jul 22 2007, Andi Kleen wrote:
> > Lars Ellenberg <lars@linbit.com> writes:
> > > 
> > > Jens, Andrew, anyone: please review,
> > > and give me advice how to proceed from here.
> > 
> > The standard procedure would be to post all the source code in logical
> > pieces on the list for review. Then iterate until all comments are
> > addressed.
> 
> Yep, cleanup the style issues (that make sense) from checkpatch and then
> psot as a series of patches that can be reviewed. Linking to a git tree
> wont get you very far.

it got me far enough, for the first try, anyways :-)
I did not spam the lkml with patches, and still got some very useful
advice (no idea how I could overlook the checkpatch.pl complaints).

If each patch of a series needs to compile and work,
there will probably only one 17kB patch...
it is difficult to split one module into a series of patches.
Or am I missing something?

may I bother you again to comment on this, please:

I am now down to
 5 CHECK: memory barrier without comment
    these are directly connected with our homegrown kernel thread stuff.
    will vanish as soon as we convert to kthread.h API.

 4 CHECK: spinlock_t definition without comment
 3 CHECK: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
 3 CHECK: if this code is redundant consider removing it
 2 CHECK: Use #include <linux/types.h> instead of <asm/types.h>
    need to check those, still.

72 ERROR: braces {} are not necessary for single statement blocks
    one branch needs them, the othe does not.
    what now? CodingStyle and checkpatch.pl disagree.

13 ERROR: no space between function name and open parenthesis '('
    this is about our ERR_IF() macro...
    suggestions, anyone?
    do need I to explicitly write these out?

 8 ERROR: Macros with multiple statements should be enclosed in a do - while loop
 1 ERROR: Macros with complex values should be enclosed in parenthesis
    these are "netlink packet definition language" in drbd_nl.h,
    which is sort of clean, and preprocessor magic in drbd_nl.c.
    suggestions how to handle this cleanly,
    without making it more ugly?
    autogenerate code by other means?
    write it out by hand, and lose the nice and clean drbd_nl.h?

 1 ERROR: Don't use kernel_thread(): see Documentation/feature-removal-schedule.txt
    yes. working on that.
    will take some days, though.

 1 ERROR: Missing Signed-off-by: line(s)

94 WARNING: declaring multiple variables together should be avoided
    int snr, enr;
    does this really need to become two lines?

33 WARNING: line over 80 characters
    hmmm. get more ugly...
    probably need some helper functions and temp variables?

 4 WARNING: multiple assignments should be avoided
    x = y = 0;
    is sometimes a convenient initialization.
    you don't like it?

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
