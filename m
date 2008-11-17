Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYKQEql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYKQEql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYKQEqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:46:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbYKQEq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:46:29 -0500
Message-ID: <4920F70D.9030100@cn.fujitsu.com>
Date: Mon, 17 Nov 2008 12:46:05 +0800
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
Subject: Re: [mm] [PATCH 4/4] Memory cgroup hierarchy feature selector (v4)
References: <20081116081034.25166.7586.sendpatchset@balbir-laptop> <20081116081105.25166.54820.sendpatchset@balbir-laptop>
In-Reply-To: <20081116081105.25166.54820.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * If parent's use_hiearchy is set, we can't make any modifications
> +	 * in the child subtrees. If it is unset, then the change can
> +	 * occur, provided the current cgroup has no children.
> +	 *
> +	 * For the root cgroup, parent_mem is NULL, we allow value to be
> +	 * set if there are no children.
> +	 */
> +	if (!parent_mem || (!parent_mem->use_hierarchy &&
> +				(val == 1 || val == 0))) {

Should be :

if ((!parent_mem || !parent_mem->use_hierarchy) &&
    (val == 1 || val == 0)) {

> +		if (list_empty(&cont->children))
> +			mem->use_hierarchy = val;
> +		else
> +			retval = -EBUSY;
> +	} else
> +		retval = -EINVAL;
> +	cgroup_unlock();
> +
> +	return retval;
> +}

