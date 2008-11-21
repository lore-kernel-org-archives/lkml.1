Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYKUIxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYKUIxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYKUIwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbYKUIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:38 -0500
Message-ID: <49267609.8050600@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCHSET] fix CGROUP VS RCU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


current some cgroup struct are protected by RCU.

struct protected by RCU:
	struct css_set, struct cgroup_subsys_state, struct cgroup

pointer protected by RCU:
	struct task_struct.cgroups, struct css_set.subsys[*],
	struct cgroup_subsys_state.cgroup
the last two pointers are readonly pointer!

these patches are fix these structs, and pointers. And a faker:
struct cgroup_subsys.root

Not cleanup all yet.

Thanx, Lai

