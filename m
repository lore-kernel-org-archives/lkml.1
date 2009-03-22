Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZCVRMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZCVRMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZCVRL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:11:27 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:53874 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZCVRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:11:26 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 2/3] Fix one sparse warning in kernel/extable.c
Date: Sun, 22 Mar 2009 19:11:10 +0200
Message-Id: <1237741871-5827-3-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
References: <1237741871-5827-1-git-send-email-dmitri.vorobiev@movial.com>
 <1237741871-5827-2-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup.

The global mutex text_mutex if declared in linux/memory.h, so
this file needs to be included into kernel/extable.c, where the
same mutex is defined. This fixes the following sparse warning:

kernel/extable.c:32:1: warning: symbol 'text_mutex' was not declared.
Should it be static?

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 kernel/extable.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index d679abb..cd9250d 100644
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
-- 
1.5.6.3

