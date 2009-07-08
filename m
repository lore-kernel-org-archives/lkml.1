Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZGHJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZGHJ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZGHJ1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:27:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:48367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbZGHJ1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:27:05 -0400
Message-ID: <4A546646.70305@kernel.org>
Date: Wed, 08 Jul 2009 18:26:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       Tony Luck <tony.luck@intel.com>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH percpu 1/2] microblaze: include EXIT_TEXT to _stext
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 09:26:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Microblaze wants to throw out EXIT_TEXT during runtime too.  This
hasn't caused trouble till now because the linker script didn't
discard EXIT_TEXT and it ended up in its default output section.  As
discard definition is about to be unified, include EXIT_TEXT into
_stext explicitly and while at it replace explicit exitcall definition
to EXIT_CALL.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Michal, I added the commit messaeg and SOB.  If you don't like it
please let me know.

If there's no further objection, I'll commit this and the next patch
to percpu#for-next.

Thanks.

 arch/microblaze/kernel/vmlinux.lds.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/arch/microblaze/kernel/vmlinux.lds.S
===================================================================
--- work.orig/arch/microblaze/kernel/vmlinux.lds.S
+++ work/arch/microblaze/kernel/vmlinux.lds.S
@@ -23,8 +23,8 @@ SECTIONS {
 		_stext = . ;
 		*(.text .text.*)
 		*(.fixup)
-
-		*(.exitcall.exit)
+               EXIT_TEXT
+               EXIT_CALL
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
