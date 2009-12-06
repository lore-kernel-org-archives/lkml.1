Return-Path: <linux-kernel-owner+w=401wt.eu-S933714AbZLFLYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbZLFLYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933673AbZLFLYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:24:30 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46186 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933671AbZLFLY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:24:29 -0500
Date: Sun, 6 Dec 2009 12:24:31 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg KH <gregkh@suse.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Doc/stable rules: add new cherry-pick logic
Message-ID: <20091206112431.GA9937@Chamillionaire.breakpoint.cc>
References: <1259736523-13091-1-git-send-email-Artem.Bityutskiy@nokia.com>
 <20091202154223.GA5895@suse.de>
 <1259823705.10805.49.camel@localhost>
 <20091204015827.GB2589@suse.de>
 <20091204111635.GA28059@Chamillionaire.breakpoint.cc>
 <20091204164126.GB1981@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091204164126.GB1981@suse.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- it is possible to submit patches for the stable queue without sending
  them directly stable@kernel.org. If the tag (Cc: stable@kernel.org) is
  available in the sign-off area than hpa's script will filter them into
  the stable mailbox once it hits Linus' tree.
- Patches which require others to be applied first can be also specified.
  This was discussued in http://lkml.org/lkml/2009/11/9/474

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 Documentation/stable_kernel_rules.txt |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index a452227..bc52bbb 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -25,14 +25,32 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree:
 
  - Send the patch, after verifying that it follows the above rules, to
-   stable@kernel.org.
+   stable@kernel.org. An alternative is to have the tag
+    Cc: stable@kernel.org
+   in the sign-off area. Once the patch is merged it will be filtered
+   into the stable tree even without sending directly to
+   stable@kernel.org
+ - If the patch requires other patches as prerequisites which can be
+   cherry-picked than this can be specified in the following format in
+   the sign-off area:
+
+    Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
+    Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
+    Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
+    Cc: <stable@kernel.org> # .32.x
+    Signed-off-by: Ingo Molnar <mingo@elte.hu>
+
+   The tag sequence has the meaning of:
+    git cherry-pick a1f84a3
+    git cherry-pick 1b9508f
+    git cherry-pick fd21073
+    git cherry-pick <this commit>
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
1.6.5.2

