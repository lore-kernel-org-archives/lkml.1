Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIXAOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIXAOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZIXAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:13:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZIXAN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:13:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=u/NghSahnuR8J42m5sWgTfKBnPIp9tSMzMVyEtB86NlvIvm5EBYCkv+LJTPJdzBJZ
	+OMiRV894LTlL9DilxpBw==
From: Paul Menage <menage@google.com>
Subject: [PATCH] Update documentation of cgroups tasks and procs files
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Sep 2009 17:12:49 -0700
Message-ID: <20090924001249.4783.91619.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update documentation of cgroups tasks and procs files

Document the cgroup.procs file.

Clarify the semantics of the cgroup.procs and tasks files.  Although
the current cgroup.procs interface returns a sorted and uniqified list
of pids, potential future performance enhancements could result in
those properties being removed - explicitly document this aspect of
the API.

There are no existing users of cgroup.procs, so compatibility isn't an
issue.  There are users of the "tasks" file, but none that would
appear to break in the event of the sorted property being broken. The
standard "libcpuset" explicitly sorts the results of reading from the
tasks file, and "libcg" and other users don't appear to care about
ordering.

Signed-off-by: Paul Menage <menage@google.com>

---

 Documentation/cgroups/cgroups.txt |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index d5be8ae..20face8 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -227,7 +227,14 @@ as the path relative to the root of the cgroup file system.
 Each cgroup is represented by a directory in the cgroup file system
 containing the following files describing that cgroup:
 
- - tasks: list of tasks (by pid) attached to that cgroup
+ - tasks: list of tasks (by pid) attached to that cgroup.  This list
+   is not guaranteed to be sorted.  Writing a thread id into this file
+   moves the thread into this cgroup.
+ - cgroup.procs: list of tgids in the cgroup.  This list is not
+   guaranteed to be sorted or free of duplicate tgids, and userspace
+   should sort/uniquify the list if this property is required.
+   Writing a tgid into this file moves all threads with that tgid into
+   this cgroup.
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)
@@ -374,7 +381,7 @@ Now you want to do something with this cgroup.
 
 In this directory you can find several files:
 # ls
-notify_on_release tasks
+cgroup.procs notify_on_release tasks
 (plus whatever files added by the attached subsystems)
 
 Now attach your shell to this cgroup:

