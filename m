Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYJCKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYJCKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJCKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:10:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:35658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYJCKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cGAV3S1fdJK1SAQ7VgbZURbrWp/XPCJoEZFnzRnbRt/M1m7P3+N0btzQl4HHECYC7z
         bLw+GGT0AFH47pnbFQy+DX8KGEB50EzTwIIsTkS9xYSpt+zfsMFweHFWBiL2xPFPAU2S
         uTCsVoVtNrB21C/6C+aG+pg4IjEPil9X7qZAI=
Message-ID: <48E5EF82.9070100@gmail.com>
Date: Fri, 03 Oct 2008 12:10:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] cpuset doesn't seem to be so const
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a warning on last -tip:

kernel/cpuset.c: Dans la fonction «scan_for_empty_cpusets» :
kernel/cpuset.c:1932: attention : passing argument 1 of «list_add_tail» discards qualifiers from pointer target type

Actually the struct cpuset *root passed in parameter to scan_for_empty_cpusets
is not supposed to be const since an entry is added on the tail of its list.
Just correct the qualifier.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 827cd9a..eab7bd6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1921,7 +1921,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
  * that has tasks along with an empty 'mems'.  But if we did see such
  * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
  */
-static void scan_for_empty_cpusets(const struct cpuset *root)
+static void scan_for_empty_cpusets(struct cpuset *root)
 {
 	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
