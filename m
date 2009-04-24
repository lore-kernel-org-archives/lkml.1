Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZDXWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZDXWHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZDXWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:07:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZDXWHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:07:32 -0400
Date: Sat, 25 Apr 2009 00:07:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424220703.GA6403@elte.hu>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org> <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com> <20090424175025.GA30091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424175025.GA30091@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Apr 24, 2009 at 11:16:18AM +0200, Fr?d?ric Weisbecker wrote:
> > I disagree with you. The kill-the-BKL tree does not only aggregate patches
> > to turn the BKL into more traditional locks. The Bkl has been
> > converted to a common mutex in
> > this tree, making it losing its common horrid properties:
> > 
> > - release/reacquire on schedule
> > - not preemptable
> > - can be reacquired recursively by a same task
> > 
> > Such a basis is very useful because we can easily find these places
> > which won't support a usual lock conversion without reworking the
> > locking scheme.
> > This is a necessary preliminary for the Bkl removal.
> > All the places which have been designed very tightly with Bkl
> > properties are rapidly detected
> > with lockdep in this tree and reworked, still using lockdep, code
> > reviewing and the help of
> > this Bkl-to-mutex conversion.
> > 
> > The work done with this tree can be merged inside and also on the
> > matching subsytem tree for
> > each patchset. That's a very sane workflow IMHO.
> 
> Having a working tree for debugging stuff is fine, but the point 
> is that it should never be pulled into mainline and probably 
> frequently reabsed to avoid cruft.  In that case there's really no 
> point in creating branches to share pieces of tree history, just 
> apply the patch locally if you think you want it and merge or 
> rebase once mainline gets the patch.
> 
> Al frequently rebases the vfs tree, btw [...]

Btw., doing that can (and will) destroy Git history and is pretty 
explicitly discouraged.

> [...] - so even if it was a separate branch now there's a fair 
> chance it would end up in mainline with a different commit id.

So did i get you right, you are advocating people to rebase their 
trees because the VFS tree is rebased often? That's pretty 
backwards.

	Ingo
