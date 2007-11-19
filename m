Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbXKSV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbXKSV77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXKSV7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:59:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXKSV7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:59:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 00/18] x86 vDSO revamp
X-Zippy-Says: ..Am I in a SOAP OPERA??
Message-Id: <20071119215944.01B7C26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 13:59:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches do a bunch of cleanup and rejiggering to the x86
vDSO implementation, but don't change any actual code in the routines in
the vDSO.  They consolidate the 32-bit vDSO code and support for it
between i386 and x86_64/ia32.  This makes them behave the same where
they didn't before (placement), and reduces a lot of duplication.  They
simplify the magic for tracking addresses inside the vDSO, which makes
it possible to remove the fragile kludges in the layout of the vDSO
images.  They consolidate the layout details and build logic for 64-bit
and 32-bit vDSOs.

Most of these patches require the earlier ones in the series, and mostly
in this order.  Patch 17 is optional without upsetting the others, and is
the only one that changes anything users might see in 32-bit processes
(aside from x86_64 behaving more like real i386).  It changes the code
addresses inside the vDSO, commonly seen in backtraces.  Nothing should
care, but anything that had previously hard-coded the expected low 0xfff
bits of those addresses could be wrong now (e.g. tests that check for
verbatim backtrace output including __kernel_* addresses).

There are several renames in here, so GIT can apply them but maybe patch
can't.  (If there is a switch to git-format-patch to produce something
more universally applicable, I haven't found it.)


Thanks,
Roland
