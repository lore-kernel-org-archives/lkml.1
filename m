Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZIJCE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZIJCE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 22:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZIJCE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 22:04:26 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:40997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbZIJCEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 22:04:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCH 0/2] __builtin_unreachable
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
Date: Wed,  9 Sep 2009 18:59:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest GCC has a better way than "for (;;)" to indicate that a code
path cannot be reached due to reasons the compiler doesn't understand (such
as code in an asm).  These patches provide UNREACHABLE() as a macro to hide
the details of this, and then use it for the BUG() macro on x86, saving
some dead code otherwise generated.

Other arch's BUG() may want to this too instead of "for (;;)" or __builtin_trap.

There are numerous matches from "git grep -n 'for *(;;) *;'" but it takes
someone who knows each bit of code to know where that means UNREACHABLE()
and where it really wants an infinite loop.


The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:
  Linus Torvalds (1):
        Linux 2.6.31

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/builtin_unreachable

Roland McGrath (2):
      UNREACHABLE() macro
      x86: BUG(): use UNREACHABLE()

 arch/x86/include/asm/bug.h    |    4 ++--
 include/linux/compiler-gcc4.h |   13 +++++++++++++
 include/linux/compiler.h      |    9 +++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)


Thanks,
Roland
