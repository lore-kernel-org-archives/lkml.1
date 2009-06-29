Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZF2W6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZF2W6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZF2W6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:58:06 -0400
Received: from baikonur.stro.at ([213.239.196.228]:51211 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZF2W6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:58:05 -0400
Date: Tue, 30 Jun 2009 00:36:46 +0200
From: maximilian attems <max@stro.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, ink@jurassic.park.msu.ru,
       rth@twiddle.net, stable@kernel.org
Subject: Re: + alpha-fix-percpu-build-breakage.patch added to -mm tree
Message-ID: <20090629223646.GI3564@stro.at>
References: <200906280107.n5S17MVD011837@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906280107.n5S17MVD011837@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jun 2009, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      alpha: fix percpu build breakage
> has been added to the -mm tree.  Its filename is
>      alpha-fix-percpu-build-breakage.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: alpha: fix percpu build breakage
> From: Tejun Heo <tj@kernel.org>
> 
> alpha percpu access requires custom SHIFT_PERCPU_PTR() definition for
> modules to work around addressing range limitation.  This is done via
> generating inline assembly using C preprocessing which forces the
> assembler to generate external reference.  This happens behind the
> compiler's back and makes the compiler think that static percpu variables
> in modules are unused.
> 
> This used to be worked around by using __unused attribute for percpu
> variables which prevent the compiler from omitting the variable; however,
> recent declare/definition attribute unification change broke this as
> __used can't be used for declaration.  Also, in the process,
> PER_CPU_ATTRIBUTES definition in alpha percpu.h got broken.
> 
> This patch adds PER_CPU_DEF_ATTRIBUTES which is only used for definitions
> and make alpha use it to add __used for percpu variables in modules.  This
> also fixes the PER_CPU_ATTRIBUTES double definition bug.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: maximilian attems <max@stro.at>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Richard Henderson <rth@twiddle.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/alpha/include/asm/percpu.h |    6 +++---
>  include/asm-generic/percpu.h    |    4 ++++
>  include/linux/percpu-defs.h     |    3 ++-
>  3 files changed, 9 insertions(+), 4 deletions(-)

verified that all Debian alpha images build fine with aboves patch.
thanks.
