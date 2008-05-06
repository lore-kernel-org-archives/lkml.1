Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYEFBd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYEFBd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYEFBdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:33:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49328 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYEFBdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:33:14 -0400
Message-ID: <481FB50D.1070308@cn.fujitsu.com>
Date: Tue, 06 May 2008 09:31:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 1/4] Setup the rlimit controller
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213736.3140.83278.sendpatchset@localhost.localdomain>
In-Reply-To: <20080503213736.3140.83278.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> +struct cgroup_subsys rlimit_cgroup_subsys;
> +
> +struct rlimit_cgroup {
> +	struct cgroup_subsys_state css;
> +	struct res_counter as_res;	/* address space counter */
> +};
> +
> +static struct rlimit_cgroup init_rlimit_cgroup;
> +
> +struct rlimit_cgroup *rlimit_cgroup_from_cgrp(struct cgroup *cgrp)

It can be static if I don't miss anything.

> +{
> +	return container_of(cgroup_subsys_state(cgrp, rlimit_cgroup_subsys_id),
> +				struct rlimit_cgroup, css);
> +}
> +

