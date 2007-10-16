Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbXJPSBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbXJPSBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764366AbXJPSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:00:12 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47885 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763381AbXJPSAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:00:08 -0400
Date: Tue, 16 Oct 2007 13:59:49 -0400
Message-Id: <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, "Mike D. Day" <ncmike@us.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Fix line number reporting 
In-reply-to: Your message of "Mon, 15 Oct 2007 19:21:18 BST."
             <20071015182118.GA4459@shadowen.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071015182118.GA4459@shadowen.org>, Andy Whitcroft writes:
> On Sat, Oct 13, 2007 at 02:35:12PM -0400, Erez Zadok wrote:
> > In message <20071012193751.GA31579@shadowen.org>, Andy Whitcroft writes:
> > > On Fri, Oct 12, 2007 at 03:26:54PM -0400, Mike D. Day wrote:
> > > > Fix line number reporting when checking source files (as opposed to
> > > > patches)
> > > > 
> > > > Signed-off-by: Mike D. Day <ncmike@us.ibm.com>
> > > 
> > > Sorry you've had to fix this about 4 times, mostly because of ongoing
> > > changes, and slow replication getting in the way.  I've applied this
> > > and you should find it in -next when replication hits.  md5sum is
> > > below of the version with it in, so you can make sure you've got
> > > the right one.
> > > 
> > > 54f053c50265e44a6041e3147dc66a69  checkpatch.pl
> > > 
> > > -apw
> > 
> > Andy, I've tested the --emacs feature in the above latest
> > checkpatch.pl-next.  Below is a patch that completes the functionality of
> > the --emacs option: it ensures that only the cc-style error messages are
> > printed, no extra context lines or caret lines, no extra newlines, etc.
> > Although this patch changes every call to a message-producing function, it
> > is a trivial change, and I believe it's the cleanest way to handle the
> > separation between the terse cc-style messages and the verbose default
> > messages.  With this patch, I can finally test a single source file as
> > follows:
> > 
> > $ ./scripts/checkpatch.pl -q -q --emacs --file path/name/to/file
> 
> Ok I don't understand why the rest of the lines are a problem?  At least
> with emacs the extra context lines are just ignored right?  Are you
> trying to use this as a summary?

Andy,

I'm trying to minimize excess stuff that's not necessarily useful for
everyone, and to match what is done elsewhere.  For example, I don't need
those extra newlines and find them a distraction.  And if get an error
message such as "put a space after a comma", I don't really need a caret
sign to point to the exact char in the line where it is.

When g/cc prints out errors from a compile, the errors are one per line, w/o
any additional context lines, caret markers, newlines, etc.  grep -n does
the same (also useful inside emacs).  So I'm just asking for a way to have
the same terse format.

If you feel that the extra info is still useful for some people, then can
you please provide a way for some people like me to turn off the extra lines
(pass a third -q, or a --terse option)?

> -apw

Thanks,
Erez.
