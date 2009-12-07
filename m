Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZLGXKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZLGXKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935635AbZLGXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:10:13 -0500
Received: from www.tglx.de ([62.245.132.106]:53858 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbZLGXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:10:12 -0500
Date: Tue, 8 Dec 2009 00:09:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jakub Jelinek <jakub@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: GCC 4.x random code generator for x86_64 ?
In-Reply-To: <20091207181301.GQ22813@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.00.0912072150450.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912071707540.3089@localhost.localdomain> <20091207181301.GQ22813@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Jakub Jelinek wrote:
> On Mon, Dec 07, 2009 at 06:50:17PM +0100, Thomas Gleixner wrote:
> > Can anyone shed some light on the following:
> > 
> > Applying a patch which adds a yet unused "extern int bla(void);" line
> > to a header file results in something which is beyond me.
> > 
> > The .i files differ as expected in exaclty _one_ line.
> 
> The source code is different, so this doesn't seem to be random code
> generation.  The extra declaration means following decls will have higher
> uids and there is a bunch of places in gcc where hash tables are traversed
> and code generation depends on the order in the traversal.  While hash
> tables hashed on pointer values are considered important bugs because
> generated code could change in between runs with the same source, traversal
> of tables hashed by decl uids are far less severe - gcc makes no promises
> that different sources result in the same generated code.

Sorry, I do not consider that delta an effective code change and I
don't think that the "no promise" answer is a good explanation for
generated code which is randomly different and in some places worse
for no good reason.

We often use(d) binary comparisions to verify that an assumed zero
change patch actually does what it promises. That way we verified the
bulk of the i386/x86_64 code move and I never saw such odd behaviour
back then (the deltas were way larger than that single line change).

> You are using quite oldish gcc, if you reproduce it with something newer

I was compiling 2.6.32 which is quite oldish code. That deserves an
quite oldish compiler. :)

Seriously, the gcc I'm using is shipped with F11 and that's what a lot
of people (still) have on their machines.

> (current 4.5 trunk or recent gcc from redhat/gcc-4_4-branch) and provide
> full preprocessed source and exact command line options, I'll have a look
> though.

F12 gcc [(GCC) 4.4.2 20091027 (Red Hat 4.4.2-7)] has similar
randomization. I'll send you the preprocessed source + command line
options tomorrow.

The current 4.5 trunk creates identical binary files with and without
the patch.

Thanks,

	tglx
