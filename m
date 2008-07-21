Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYGUXzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYGUXzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYGUXy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:54:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGUXy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:54:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: Ingo Molnar's message of  Friday, 18 July 2008 13:36:15 +0200 <20080718113615.GD6875@elte.hu>
References: <20080707065615.77BD9154246@magilla.localdomain>
	<20080707065742.7C119154246@magilla.localdomain>
	<alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
	<20080708000233.E8EF3154244@magilla.localdomain>
	<20080718113615.GD6875@elte.hu>
Emacs: the only text editor known to get indigestion.
Message-Id: <20080721235419.CA3BA1541A5@magilla.localdomain>
Date: Mon, 21 Jul 2008 16:54:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do you have a delta patch against tip/x86/audit-speedup by any chance? 
> That is a topic branch of your previous drop, which got tested as well 
> to a certain degree. Would make it easier to see what changed, would 
> make the merge have a more nuanced history, etc.
> 
> or, alternatively, if you have a -git based branch that i could pull, 
> that would be nice as well. (i can compare old-x86/audit-speedup to 
> new-x86/audit-speedup.)

Here is a GIT branch with freshly-rebased patches from today's upstream.
There was some merging fixup to be done after the x86/step changes went in.

I don't think it's useful to have a history merged upstream that includes
the original broken 3/4 patch.  The newer version both has the straight
line paths Linus wanted, and works right on AMD.  If we had the old version
in GIT, then there would be a point in the history that builds a kernel
that's broken for all 32-bit processes on 64-bit AMD hardware.  Anyone
doing a bisect in the future could get unlucky hit that along the way, etc.
Anyway, you'd have to redo this merging work with x86/step just to get one
that builds now.

The following changes since commit 93ded9b8fd42abe2c3607097963d8de6ad9117eb:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/auditsc

Roland McGrath (4):
      x86_64: remove bogus optimization in sysret_signal
      x86_64 syscall audit fast-path
      x86_64 ia32 syscall audit fast-path
      i386 syscall audit fast-path

 arch/x86/ia32/ia32entry.S  |   78 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/entry_32.S |   48 ++++++++++++++++++++++++++-
 arch/x86/kernel/entry_64.S |   49 +++++++++++++++++++++++++---
 kernel/auditsc.c           |    3 +-
 4 files changed, 166 insertions(+), 12 deletions(-)


Thanks,
Roland
