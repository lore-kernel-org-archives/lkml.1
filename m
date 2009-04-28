Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZD1E4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZD1E4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZD1E4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:56:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60439 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZD1E4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:56:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
Date: Tue, 28 Apr 2009 14:56:33 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Abbott <tabbott@MIT.EDU>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Please revert edada399 and 9203fc9c
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please revert commits edada399 ("powerpc: Use TEXT_TEXT macro in
linker script.") and 9203fc9c ("powerpc: Use __REF macro instead of
old .text.init.refok."), which depends on edada399.

Commit edada399 breaks the build because it moves the __ftr_alt_*
sections of a file away from the .text section, causing link failures
due to relative conditional branch targets being too far away from the
branch instructions.  This happens on pretty much all 64-bit powerpc
configs.

Clearly these patches were never even build-tested.  They were never
acked by the powerpc maintainer (Ben) - because he was on vacation -
and they weren't sent to the deputy maintainer (me) or the relevant
mailing list (linuxppc-dev).

And they are clearly not fixes for regressions or serious bugs, so why
are these patches going in after -rc3 anyway?

Paul.
