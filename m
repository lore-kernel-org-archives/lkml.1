Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663Ab0A2HER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0A2HER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203Ab0A2HEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0A2HEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:04:15 -0500
Date: Fri, 29 Jan 2010 02:01:53 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org
Message-Id: <20100129070516.4058.77227.sendpatchset@localhost.localdomain>
Subject: [Patch 0/2] sysfs: fix s_active lockdep warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
As reported by several people, it is something like:

[ 6967.926563] ACPI: Preparing to enter system sleep state S3
[ 6967.956156] Disabling non-boot CPUs ...
[ 6967.970401]
[ 6967.970408] =============================================
[ 6967.970419] [ INFO: possible recursive locking detected ]
[ 6967.970431] 2.6.33-rc2-git6 #27
[ 6967.970439] ---------------------------------------------
[ 6967.970450] pm-suspend/22147 is trying to acquire lock:
[ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
sysfs_hash_and_remove+0x3d/0x4f
[ 6967.970493]
[ 6967.970497] but task is already holding lock:
[ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
sysfs_get_active_two+0x16/0x36
[...]

Eric already provides a patch for this[1], but it still can't fix the
problem. I add the missing part of Eric's patch and send these two patches
together, hopefully we can fix the warning completely.

1. http://lkml.org/lkml/2010/1/10/282


Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Miles Lane <miles.lane@gmail.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

