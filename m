Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbYEEVwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbYEEVwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760472AbYEEVvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:51:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39319 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929AbYEEVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:51:51 -0400
Date: Mon, 5 May 2008 14:51:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505145132.58df7e70@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0805051327530.27703@shark.he.net>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
	<Pine.LNX.4.64.0805051327530.27703@shark.he.net>
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

On Mon, 5 May 2008 13:40:53 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Mon, 5 May 2008, Ingo Molnar wrote:
> 
> > And unlike other kernel developers, my opinion is not that we
> > should eliminate this disruption by not doing these trivial patches
> > _at all_. My opinion is that we should make it easier for
> > maintainers to _avoid introducing_ these problems.
> > 
> > I.e. we need to fight the root of this problem (the steady
> > introduction of needlessly global symbols), not its symptoms (the
> > needlessly global symbols themselves).
> 
> in some automated ways...
> 
> We have Documentation/SubmitChecklist that we hope that patch
> submitters will use, but we have little evidence that they (we) do
> use it, and we have some evidence that they (we) do NOT use it.
> (but this isn't automated)
> 
> I see being related to DaveM's "Slow down, please" thread.
> We have developers hurriedly writing new code but not paying enough
> attention to code that they have already written.
> (not directed at anyone in particular)
> 
> E.g., you do maybe 200 randconfig builds per day.  I only do
> 20 - 50, but we both find too many problems (IMHO).
> 
> > Let me raise some thoughts about what we could do to achieve these 
> > goals.
> 
> Good discussion material.
> 


can we do a "make patchcheck" kernel build target that would
* run checkpatch on teh patch
* build the kernel without the patch (in various .configs, probably
allyesconfig / allmodconfig is enough, but we can figure this out
later)
* apply the patch
* build the kernel in the same configs
* build a kernel for install that has the 'standard debug options' on
  (lockdep, slabpoison etc)
then we can
* compare if new gcc warnings got introduced
* compare if major stack usage got introduced
* compare if namespace_check and some of the others introduce new issues
* compare if new sparse warnings got introduced
and maybe even run a bloat-o-meter to show code growth/shrinkage
[insert other useful checks here]

if all of that is just one command away, I bet quite a few people would
use it
(and the more useful it gets the more people will use it)

yes you can do the same thing by hand.
but yes it's many steps that are cumbersome if not automated... so few
people will do it.

If it's all in one step... 


