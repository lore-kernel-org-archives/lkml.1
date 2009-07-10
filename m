Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZGJXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZGJXCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZGJXCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:02:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbZGJXCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:02:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:x-system-of-record;
	b=yAl3xQYS0ksmazmVC630f70OxpW184fZ7Q2vZ1f1JMoc3HYc2PV6wq1lcW7A57PfB
	vZa2OUrUmk9da2fdHA7gA==
From: Ben Blum <bblum@google.com>
Subject: [PATCH v2 0/3] CGroups: cgroup member list enhancement/fix
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Date: Fri, 10 Jul 2009 16:01:49 -0700
Message-ID: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is a revision of the patch series in http://lkml.org/lkml/2009/7/2/464 )

The following series adds a "cgroup.procs" file to each cgroup that reports
unique tgids rather than pids, and fixes a pid namespace bug in the existing
"tasks" file that could cause readers in different namespaces to interfere
with one another.

This patch series implements a superset of the functionality of (and was
written at the same time as) Li Zefan's pid namespace bugfix patch (from
http://lkml.org/lkml/2009/7/1/559 ). These patches can either be rewritten to
be applied on top of Li's patch, or be applied as they are with Li's patch
reversed.

---

Ben Blum (3):
      Quick vmalloc vs kmalloc fix to the case where array size is too large
      Ensures correct concurrent opening/reading of pidlists across pid namespaces
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids


 include/linux/cgroup.h |   46 +++++-
 kernel/cgroup.c        |  378 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 309 insertions(+), 115 deletions(-)

