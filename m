Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZGBCLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZGBCLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZGBCLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:11:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZGBCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:11:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=tYR784URNpOxfHZoAER/BJeo9rANqL0ikEBRaqyNo84fsVoNQ1zNWC2kmd6LqsnBG
	81M6jDcIRFP+Okj6o9DDg==
From: Paul Menage <menage@google.com>
Subject: [PATCH 0/9] [RFC] CGroup Hierarchy Extensions
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Date: Wed, 01 Jul 2009 19:10:52 -0700
Message-ID: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds support for:

- named cgroup hierarchies
- cgroup hierarchies with no bound subsystems
- cgroup subsystems that can be bound to multiple hierarchies

This allows more flexibility when constructing/mounting cgroups
hierarchies, and allows functionality that's not tied to specific
external resources to be made available on multiple cgroups
hierarchies rather than just one.

A few simple example cgroups subsystems that are multi-bindable are
included in the patch series.

---

Paul Menage (9):
      [RFC] Support named cgroups hierarchies
      [RFC] Move the cgroup debug subsys into cgroup.c to access internal state
      [RFC] Add a back-pointer from struct cg_cgroup_link to struct cgroup
      [RFC] Allow cgroup hierarchies to be created with no bound subsystems
      [RFC] Remove cgroup_subsys.root pointer
      [RFC] Remove the cgroup_subsys.bind callback
      [RFC] Support multiply-bindable cgroup subsystems
      [RFC] Example multi-bindable subsystem: a per-cgroup notes field
      [RFC] Example multi-bindable subsystem: a max-depth controller


 Documentation/cgroups/cgroups.txt |    8 
 include/linux/cgroup.h            |   55 ++
 include/linux/cgroup_subsys.h     |   14 +
 init/Kconfig                      |   17 +
 kernel/Makefile                   |    3 
 kernel/cgroup.c                   |  905 +++++++++++++++++++++++++++----------
 kernel/cgroup_debug.c             |  105 ----
 kernel/info_cgroup.c              |  133 +++++
 kernel/maxdepth_cgroup.c          |   80 +++
 9 files changed, 938 insertions(+), 382 deletions(-)
 delete mode 100644 kernel/cgroup_debug.c
 create mode 100644 kernel/info_cgroup.c
 create mode 100644 kernel/maxdepth_cgroup.c

