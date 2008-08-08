Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYHHBpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYHHBpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHHBpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:45:25 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:43279 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYHHBpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:45:24 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Petr Baudis <pasky@suse.cz>, "Shawn O. Pearce" <spearce@spearce.org>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>
Subject: [PATCH] powerpc: Do not ignore arch/powerpc/include
References: <20080721002354.GK10151@machine.or.cz>
 <20080721002508.26773.92277.stgit@localhost>
 <7v8wvpm9cl.fsf@gitster.siamese.dyndns.org>
 <7vej5543v5.fsf_-_@gitster.siamese.dyndns.org>
 <alpine.LFD.1.10.0808041719380.3299@nehalem.linux-foundation.org>
 <7vk5etjozt.fsf@gitster.siamese.dyndns.org>
Date: Thu, 07 Aug 2008 18:45:08 -0700
In-Reply-To: <7vk5etjozt.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's
 message of "Wed, 06 Aug 2008 23:52:38 -0700")
Message-ID: <7vzlnogtzv.fsf_-_@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: A85504BA-64EB-11DD-B63F-3113EBD4C077-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back when .gitignore file was added to arch/powerpc/ in 06f2138 ([POWERPC]
Add files build to .gitignore, 2006-11-26), there indeed was nothing
tracked in the ignored hierarchy and ignoring everything made sense.  But
we have very many tracked files there these days, and having a higher
level .gitignore that ignores everything is asking for future troubles..

This should have been part of b8b572e (powerpc: Move include files to
arch/powerpc/include/asm, 2008-08-01).

Signed-off-by: Junio C Hamano <gitster@pobox.com>
---
  Junio C Hamano <gitster@pobox.com> writes:

  > By the way, if anybody wants to reproduce this, be careful with the
  > tests that run "rm -f .git/index" before adding everything with
  > "git add ."  from the toplevel directory.  After doing so, if you check
  > the result with "git diff --stat HEAD", you will notice many missing files;
  > I almost got a heart attack before inspecting this file:
  >
  > 	$ cat arch/powerpc/.gitignore
  >         include
  >
  > Yes, it excludes 261 already tracked files.  Is it intended?  I dunno.

  I looked at this a bit more and now I know this was not intended.

 arch/powerpc/.gitignore |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/.gitignore b/arch/powerpc/.gitignore
deleted file mode 100644
index a1a869c..0000000
--- a/arch/powerpc/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-include

