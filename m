Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbXIQVWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbXIQVWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXIQVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:22:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXIQVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:22:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=FZDqYZf6cZyPdCOYq6ZeeBYzFQ+/E0APTcvWTf4bHG8/FNW7LEfxVQzwWcdGQ9yiD
	ETm4tiNmdMZsH9SKLsaiA==
Message-Id: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:07 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/33] Rename "Task Containers" to "Control Groups"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--


This patchset renames "Task Containers" to "Control Groups", in line with
recent discussions.

These patches are drop-in replacements for those of the same names in
the current -mm tree, as listed at the bottom of this email. I have
tried to keep the patch names (based on the description lines of each
patch) the same even where such patch names refer to "containers"
rather than "cgroups" - hopefully after these have been imported into
-mm, Andrew can rename the patches in his quilt stack.

Note that the Signed-off-by lines in these patches (other than mine)
refer to the original versions of these patches, before the rename. I
believe that all such original authors were Cc'd on the review email
last week and no-one has objected to the rename.

The new patches are constructed by running the following perl script
over the original versions of the patches in 2.6.23-rc4-mm1 (and others seen on mm-commits since then):

perl -pi -e 's/subcontainer/child cgroup/g; s/(\b|_)container(\b|_(?!of)|fs|s)/$1cgroup$2/g; s/CONTAINER(_|S)/CGROUP$1/g; s/Container/Control Group/g; s/css_group/css_set/g;' patches/*.patch

Owners of other control-group related patches may want to run this
script or some variation of it on their own patches.

Replaced patches
================

task-containersv11-basic-task-container-framework.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch

task-containersv11-basic-task-container-framework-containers-fix-refcount-bug.patch
task-containersv11-add-container_clone-interface-containers-fix-refcount-bug.patch

add-containerstats-v3.patch
add-containerstats-v3-fix.patch

containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch

memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-make-charging-gfp-mask-aware.patch

