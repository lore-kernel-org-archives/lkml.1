Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbYEFDYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbYEFDYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYEFDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:24:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51612 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYEFDYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:24:07 -0400
Date: Mon, 5 May 2008 20:23:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505202321.3ea086d0@infradead.org>
In-Reply-To: <20080505234515.GB8357@mit.edu>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
	<Pine.LNX.4.64.0805051327530.27703@shark.he.net>
	<20080505145132.58df7e70@infradead.org>
	<20080505234515.GB8357@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 19:45:15 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, May 05, 2008 at 02:51:32PM -0700, Arjan van de Ven wrote:
> > can we do a "make patchcheck" kernel build target that would
> > * run checkpatch on teh patch
> > * build the kernel without the patch (in various .configs, probably
> > allyesconfig / allmodconfig is enough, but we can figure this out
> > later)
> > * apply the patch
> > * build the kernel in the same configs
> > * build a kernel for install that has the 'standard debug options'
> > on (lockdep, slabpoison etc)
> > then we can
> > * compare if new gcc warnings got introduced
> > * compare if major stack usage got introduced
> > * compare if namespace_check and some of the others introduce new
> > issues
> > * compare if new sparse warnings got introduced
> > and maybe even run a bloat-o-meter to show code growth/shrinkage
> > [insert other useful checks here]
> > 
> > if all of that is just one command away, I bet quite a few people
> > would use it
> > (and the more useful it gets the more people will use it)
> 
> I'm not sure we could do it for every single patch (because of the
> time it would take), 

I don't think build power is an actual problem for things like this,
since it tends to distribute really well.
