Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0CAS2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:28:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:56557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0CAS23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,561,1262592000"; 
   d="scan'208";a="249461319"
Subject: Re: [RFC GIT PULL] x86/pat changes for v2.6.34
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100227163636.GA10646@elte.hu>
References: <20100227163636.GA10646@elte.hu>
Content-Type: text/plain
Date: Mon, 01 Mar 2010 10:28:28 -0800
Message-Id: <1267468108.16916.937.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 08:36 -0800, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-pat-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-pat-for-linus
> 
> Please have a look at the lib/rbtree.c changes. The rebalancing changes ought
> to not impact performance - rb_erase() possibly in a small way. Should this
> perhaps be done via a separate API entry, instead of modifying existing rbtree
> code?
> 
> out-of-topic modifications in x86-pat-for-linus:
> ------------------------------------------------
> include/linux/rbtree.h             # 17d9ddc: rbtree: Add support for augmented
> lib/rbtree.c                       # 17d9ddc: rbtree: Add support for augmented
> 
>  Thanks,
> 
>         Ingo
> 
> ------------------>
> Pallipadi, Venkatesh (2):
>       rbtree: Add support for augmented rbtrees
>       x86, pat: Migrate to rbtree only backend for pat memtype management
> 
> venkatesh.pallipadi@intel.com (1):
>       x86, pat: Preparatory changes in pat.c for bigger rbtree change


There are few dependencies with this patchset.

These patches should go in before "Add support for augmented rbtrees":

"btrfs: use RB_ROOT to intialize rb_trees instead of settingrb_node to
NULL"
http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/02946.html

"[patch 0/3] Fixup rb_root initializations to use RB_ROOT"
http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/03037.html


And this is an x86 bug fix on top of "Migrate to rbtree only backend for
pat memtype management"
http://lkml.indiana.edu/hypermail/linux/kernel/1002.3/00346.html


Thanks,
Venki

