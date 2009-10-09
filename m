Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbZJIXRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbZJIXRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbZJIXRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:17 -0400
Received: from kroah.org ([198.145.64.141]:36843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761563AbZJIXRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:00 2009
Message-Id: <20091009231000.889034070@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 06/26] ftrace: check for failure for all conversions
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=ftrace-check-for-failure-for-all-conversions.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steven Rostedt <srostedt@redhat.com>

commit 3279ba37db5d65c4ab0dcdee3b211ccb85bb563f upstream.

Due to legacy code from back when the dynamic tracer used a daemon,
only core kernel code was checking for failures. This is no longer
the case. We must check for failures any time we perform text modifications.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1110,14 +1110,9 @@ static void ftrace_replace_code(int enab
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
 			rec->flags |= FTRACE_FL_FAILED;
-			if ((system_state == SYSTEM_BOOTING) ||
-			    !core_kernel_text(rec->ip)) {
-				ftrace_free_rec(rec);
-				} else {
-				ftrace_bug(failed, rec->ip);
-					/* Stop processing */
-					return;
-				}
+			ftrace_bug(failed, rec->ip);
+			/* Stop processing */
+			return;
 		}
 	} while_for_each_ftrace_rec();
 }


