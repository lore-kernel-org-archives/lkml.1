Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZFRWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZFRWcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZFRWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:32:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZFRWcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:32:02 -0400
Message-ID: <4A3AC0BA.4000407@kernel.org>
Date: Fri, 19 Jun 2009 07:33:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 22:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> 
> On Thu, 18 Jun 2009, Tejun Heo wrote:
>> Please pull from percpu-for-linus git tree from:
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> 
> I'm very unhappy with this kind of crap.
> 
> Has it been tested AT ALL? Apparently not.
> 
> 	arch/x86/kernel/cpu/mcheck/mce.c:98: error: multiple storage classes in declaration specifiers
> 	arch/x86/kernel/cpu/mcheck/mce.c:98: error: non-static declaration of ¡per_cpu__mces_seen¢ follows static declaration
> 	arch/x86/kernel/cpu/mcheck/mce.c:98: note: previous declaration of ¡per_cpu__mces_seen¢ was here
> 	.. and tons of other similar errors ..

Oops, my apologies.  I had them as floating series and apparently used
different base commit when applying them.  I did grep run and full yes
build on the original quilt tree but didn't after quiltimport.  Sorry.

> and it was apparently done on purpose, for no good reason. The bug with 
> static per-cpu variables is only for some broken architectures.

Yes, for two of them s390 and alpha.  Another route was to tell the
compiler to generate external references were to use weak attribute
which also required globally unique name.  The first take of the
patchset used guard symbols to guarantee variable scope
(static/extern) and uniqueness while using weak attribute for the
actual percpu symbol.  It worked but was a bit too complex.  Consensus
(at least of the ones involved in the discussion) was limiting percpu
definitions to extern is an acceptable compromise.

> Even the _documentation_ uses "static DEFINE_PER_CPU(..)" for chissake!

Yeap, that was me going through grep output and thinking oh... I'll do
it later and then forget about it.  Will update now.

> To make matters worse, this whole series was clearly rebased (or applied 
> from some other queue) just _minutes_ before sending it to me. No wonder 
> it had zero testing:
> 
>  - commit:
> 	Date: Thu Jun 18 16:22:05 2009 +0900
>  - email:
> 	Date: Thu, 18 Jun 2009 17:07:16 +0900
> 
> I'm not pulling it. Or rather, I pulled it, ended up doing other work, 
> noticed the problems, and had to re-do my whole tree because I refuse to 
> have sh*t like this in the kernel.
> 
> And I'm not going to pull trees that get rebased like this with basically 
> no testing before sending it to me. There's a reason I don't like 
> rebasing.

Percpu patches used to run through Ingo's x86 tree (so reached
linux-next from there) but recent changes went out of scope for x86 so
the two patchsets posted here didn't have home.  They were posted well
before the merge window (IIRC the first postings were about two months
ago) and went through four and three revision cycles.

The tree was prepared in kind of hurry because I realized that no one
was gonna push it through a few days ago.  It's true that these
patches didn't see wider testing in linux-next or any other public
tree, so it seems these should wait for the next merge window.  I'll
maintain the percpu tree and push it through linux-next during this
devel cycle.

Sorry about the trouble.

Thanks.

-- 
tejun
