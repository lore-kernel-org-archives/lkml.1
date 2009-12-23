Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZLWTzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZLWTzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbZLWTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:16 -0500
Received: from kroah.org ([198.145.64.141]:52942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbZLWTxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Brandon Philips <brandon@ifup.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/10] Doc/stable rules: add new cherry-pick logic
Date: Wed, 23 Dec 2009 11:52:36 -0800
Message-Id: <1261597963-18323-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

- it is possible to submit patches for the stable queue without sending
  them directly stable@kernel.org. If the tag (Cc: stable@kernel.org) is
  available in the sign-off area than hpa's script will filter them into
  the stable mailbox once it hits Linus' tree.
- Patches which require others to be applied first can be also specified.
  This was discussued in http://lkml.org/lkml/2009/11/9/474

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Brandon Philips <brandon@ifup.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/stable_kernel_rules.txt |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index a452227..5effa5b 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -26,13 +26,33 @@ Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
    stable@kernel.org.
+ - To have the patch automatically included in the stable tree, add the
+   the tag
+     Cc: stable@kernel.org
+   in the sign-off area. Once the patch is merged it will be applied to
+   the stable tree without anything else needing to be done by the author
+   or subsystem maintainer.
+ - If the patch requires other patches as prerequisites which can be
+   cherry-picked than this can be specified in the following format in
+   the sign-off area:
+
+     Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for idle
+     Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
+     Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
+     Cc: <stable@kernel.org> # .32.x
+    Signed-off-by: Ingo Molnar <mingo@elte.hu>
+
+   The tag sequence has the meaning of:
+     git cherry-pick a1f84a3
+     git cherry-pick 1b9508f
+     git cherry-pick fd21073
+     git cherry-pick <this commit>
+
  - The sender will receive an ACK when the patch has been accepted into the
    queue, or a NAK if the patch is rejected.  This response might take a few
    days, according to the developer's schedules.
  - If accepted, the patch will be added to the -stable queue, for review by
    other developers and by the relevant subsystem maintainer.
- - If the stable@kernel.org address is added to a patch, when it goes into
-   Linus's tree it will automatically be emailed to the stable team.
  - Security patches should not be sent to this alias, but instead to the
    documented security@kernel.org address.
 
-- 
1.6.5.7

