Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZEaIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZEaIjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbZEaIjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 04:39:03 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:5507 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbZEaIjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 04:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B9PLeoeJQTQ5zdz+uqmyulBUfjTEnlrh1pDwCTy8Jt/EwTupHTGEIARLXXFCwIO5Rw
         GSQCv/Ea1F3gbvsjegtDE4SXx9aAvnWJWn2Eg+DdgK/kFI47UhwQBD22lDowbz1rFyuF
         pG5XC7tsS29UQJfDpC4J3iRQfOPYConVKYcjE=
MIME-Version: 1.0
In-Reply-To: <1faf47660905310128t45f1ea32ge5e1cba82ddca972@mail.gmail.com>
References: <1faf47660905310128t45f1ea32ge5e1cba82ddca972@mail.gmail.com>
Date: Sun, 31 May 2009 01:39:01 -0700
Message-ID: <1faf47660905310139y7203bba7w39f4a5330b148f0@mail.gmail.com>
Subject: Fwd: BUG: Documentation/lguest/lguest.c bad paths for includes cause 
	make to fail
From: "Charles 'Mack' Rhinelander" <mrhinelander@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, lguest@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Charles 'Mack' Rhinelander <mrhinelander@gmail.com>
Date: Sun, May 31, 2009 at 1:28 AM
Subject: BUG: Documentation/lguest/lguest.c bad paths for includes
cause make to fail
To: mm-commits@vger.kernel.org, kraai@ftbfs.org,
rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>, Thomas Gleixner
<tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>


2.6.28-rc2-mm1 make fails at Documentation/lguest/lguest.c  Two
includes have bad paths: line 34 #include <zlib.h> (maybe should be
linux/zlib.h?), and line 47 #include "asm-x86/bootparam.h"

Are incorrect paths related to this recent gitignore of lguest.c (see
first cut below)?

asm-x86 has no bootparam.h; is this related to 2007 mm-commit list
concerning "allow asm-x86 to be included from userspace?" (see second
cut below)

---BEGIN CUT ABOUT gitignore OF lguest.c---

Gitweb:     http://git.kernel.org/linus/9536c26b31ae34ba6371a1b8f406028e9756f913
Commit:     9536c26b31ae34ba6371a1b8f406028e9756f913
Parent:     84a139a985300901dfad99bd93c7345d180af860
Author:     Matt Kraai <kraai@ftbfs.org>
AuthorDate: Thu Apr 16 23:46:20 2009 -0700
Committer:  Rusty Russell <rusty@rustcorp.com.au>
CommitDate: Sun Apr 19 23:14:02 2009 +0930

   lguest: tell git to ignore Documentation/lguest/lguest

   This is the example lguest launcher binary.

   Signed-off-by: Matt Kraai <kraai@ftbfs.org>
   Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/lguest/.gitignore b/Documentation/lguest/.gitignore
---END CUT---

---BEGIN CUT ABOUT allow x86 bootparam include from userspace---
List:       linux-mm-commits
Subject:    - make-asm-x86-bootparamh-includable-from-userspace.patch
removed from -mm tree
From:       akpm () linux-foundation ! org
Date:       2007-10-18 6:05:37

The patch titled
    Make asm-x86/bootparam.h includable from userspace
has been removed from the -mm tree.  Its filename was
    make-asm-x86-bootparamh-includable-from-userspace.patch

This patch was dropped because because of rejects

------------------------------------------------------
Subject: Make asm-x86/bootparam.h includable from userspace
From: Rusty Russell <rusty@rustcorp.com.au>

To actually write a bootloader (or, say, the lguest launcher) currently
requires duplication of these structures.  Making them includeable from
userspace is much nicer.

We merge the common userspace-required definitions of e820_32/64.h into e820.h
for export.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org
---END CUT---
