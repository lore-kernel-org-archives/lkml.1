Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYLKDHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYLKDHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 22:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYLKDGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 22:06:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYLKDGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 22:06:49 -0500
Message-ID: <4940836A.9010502@cn.fujitsu.com>
Date: Thu, 11 Dec 2008 11:05:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: menage@google.com
CC: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
References: <20081210233654.563182000@menage.corp.google.com> <20081210234432.065445000@menage.corp.google.com>
In-Reply-To: <20081210234432.065445000@menage.corp.google.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
> +{
> +	/* We need to take each hierarchy_mutex in a consistent order */

This comment is not so clear. Do you mean for_each_subsys() can't be
used here?

But this function is used in cgroup.c internally, and always called
with cgroup_lock held, so it's OK to use for_each_subsys().

> +	int i;
> +
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		struct cgroup_subsys *ss = subsys[i];
> +		if (ss->root == root)
> +			mutex_lock_nested(&ss->hierarchy_mutex, i);
> +	}
> +}

