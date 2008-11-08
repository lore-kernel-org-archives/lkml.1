Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKHJm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKHJm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYKHJmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:42:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62434 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYKHJmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:42:16 -0500
Message-ID: <49155E45.3030704@cn.fujitsu.com>
Date: Sat, 08 Nov 2008 17:39:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v2)
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain> <20081108091113.32236.12390.sendpatchset@localhost.localdomain>
In-Reply-To: <20081108091113.32236.12390.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
> +					u64 val)
> +{
> +	int retval = 0;
> +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> +
> +	if (val == 1) {
> +		if (list_empty(&cont->children))

cgroup_lock should be held before checking cont->children.

> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else if (val == 0) {

And code duplicate.

> +		if (list_empty(&cont->children))
> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else
> +		retval = -EINVAL;
> +
> +	return retval;
> +}
> +

