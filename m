Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYLBDSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYLBDSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYLBDRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:17:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYLBDRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:17:54 -0500
Message-ID: <4934A8FB.80904@cn.fujitsu.com>
Date: Tue, 02 Dec 2008 11:18:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 3/3] cgroups: introduce link_css_set() to remove duplicate
 	code
References: <492FC1C2.9050001@cn.fujitsu.com> <6599ad830812011620ld861aabgc70846a07ce1d487@mail.gmail.com>
In-Reply-To: <6599ad830812011620ld861aabgc70846a07ce1d487@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 28, 2008 at 2:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Add a common function link_css_set() to link a css_set to a cgroup.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Overall the change looks like an improvement, but:
> 
> - the new function could do with comments about the semantics of its
> parameters, particularly tmp_cg_links.

How about:

/**
 * link_css_set - a helper function to link a css_set to a cgroup
 * @ tmp_cg_links: cg_cgroup_link objects allocated by allocate_cg_links()
 * @ cg: the css_set to be linked
 * @ cgrp: the destination cgroup
 */
static void link_css_set(struct list_head *tmp_cg_links,
			 struct css_set *cg, struct cgroup *cgrp)

> - why are you renaming cgrp -> root_cgrp in cgroup_get_sb()? That
> seems like unnecessary churn.
> 

Because we are linking all the css_sets to the root cgroup, so I think root_cgrp
helps readability.

