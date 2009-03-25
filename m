Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZCYJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZCYJrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZCYJrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:46378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbZCYJrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:00 -0400
Date: Wed, 25 Mar 2009 09:45:44 GMT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dmitri.vorobiev@movial.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dmitri.vorobiev@movial.com, mingo@elte.hu
In-Reply-To: <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
Subject: [tip:tracing/core] tracing, Text Edit Lock: Fix one sparse warning in kernel/extable.c
Message-ID: <tip-f80d2d7725b04f8225b11b55e43bb2c77c819926@git.kernel.org>
Git-Commit-ID: f80d2d7725b04f8225b11b55e43bb2c77c819926
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:45:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f80d2d7725b04f8225b11b55e43bb2c77c819926
Gitweb:     http://git.kernel.org/tip/f80d2d7725b04f8225b11b55e43bb2c77c819926
Author:     Dmitri Vorobiev <dmitri.vorobiev@movial.com>
AuthorDate: Sun, 22 Mar 2009 19:11:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:16:20 +0100

tracing, Text Edit Lock: Fix one sparse warning in kernel/extable.c

Impact: cleanup.

The global mutex text_mutex if declared in linux/memory.h, so
this file needs to be included into kernel/extable.c, where the
same mutex is defined. This fixes the following sparse warning:

 kernel/extable.c:32:1: warning: symbol 'text_mutex' was not declared.
 Should it be static?

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
LKML-Reference: <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/extable.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 25d39b0..b54a601 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -16,6 +16,7 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 #include <linux/ftrace.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
