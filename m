Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZGBX0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZGBX0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZGBX0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:26:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZGBX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:26:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=Q7adP3UAiHwZZAJo0LJY7ozNeDo+vr4iN5CivQ+7jtgf34YvWR4brefIw8+cvZLUi
	jd8oOt/P6CVCjp9IqPSBw==
From: Paul Menage <menage@google.com>
Subject: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
To: lizf@cn.fujitzu.com, serue@us.ibm.com, akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@google.com
Date: Thu, 02 Jul 2009 16:26:15 -0700
Message-ID: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series (written by Ben Blum) adds a "cgroup.procs" file
to each cgroup that reports unique tgids rather than pids, and fixes a
pid namespace bug in the existing "tasks" file that could cause
readers in different namespaces to interfere with one another.

The patches as a pair provide similar functionality to Li Zefan's
patch posted yesterday, with the addition on the "cgroup.procs" file;
if it's decided that Li's patch needs to be fast-tracked to 2.6.31,
then these patches can be rebased as a small extension of Li's patch;
if Li'z patch doesn't need to go to 2.6.31 then it makes more sense to
take this pair since they provide more overall functionality.

---

Ben Blum (2):
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids
      Ensures correct concurrent opening/reading of pidlists across pid namespaces


 include/linux/cgroup.h |   46 +++++-
 kernel/cgroup.c        |  355 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 285 insertions(+), 116 deletions(-)

