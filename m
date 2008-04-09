Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYDIAGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYDIAGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYDIAGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:06:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYDIAGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:06:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=ZlWNA2gOyymt5nuZWg+NCuyDiKF3hxCy67fHb6cHik9eO+78YJP3NFAsRnYz/qSh+
	OZVfzytQUyoCgCGqEgYGg==
Message-ID: <47FC085F.2070709@google.com>
Date: Tue, 08 Apr 2008 17:05:51 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: containers@lists.linux-foundation.org
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] CGroups: Include hierarchy ids in /proc/<pid>/cgroup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ The RFC associated with this patch is whether there's a better way to export such information in a way that's simultaneously extensible, human-readable and machine-parsable ]

CGroups: Include hierarchy ids in /proc/<pid>/cgroup

This patch extends the /proc/<pid>/cgroup file to include the
appropriate hierarchy ID on each line. Currently this ID isn't really
needed since a hierarchy can be completely identified by the set of
subsystems bound to it, but this is likely to change in the near
future in order to support stateless subsystems and merging/rebinding
of subsystems. Getting this change into 2.6.25 reduces the need for
an API change later.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

Index: cgroup-2.6.25-rc8-mm1/kernel/cgroup.c
===================================================================
--- cgroup-2.6.25-rc8-mm1.orig/kernel/cgroup.c
+++ cgroup-2.6.25-rc8-mm1/kernel/cgroup.c
@@ -2613,6 +2613,7 @@ static int proc_cgroup_show(struct seq_f
 		/* Skip this hierarchy if it has no active subsystems */
 		if (!root->actual_subsys_bits)
 			continue;
+		seq_printf(m, "%lu:", root->subsys_bits);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
 		seq_putc(m, ':');
