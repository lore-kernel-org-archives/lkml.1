Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYIPMY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYIPMY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIPMYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:24:18 -0400
Received: from sacred.ru ([62.205.161.221]:39247 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYIPMYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:24:17 -0400
Message-ID: <48CFA549.5010500@openvz.org>
Date: Tue, 16 Sep 2008 16:23:37 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: balbir@linux.vnet.ibm.com, "hugh@veritas.com" <hugh@veritas.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, menage@google.com,
       Dave Hansen <haveblue@us.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 11/9] lazy lru free vector for memcg
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>	<20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>	<48CA9500.5060309@linux.vnet.ibm.com>	<20080916211355.277b625d.kamezawa.hiroyu@jp.fujitsu.com> <20080916211934.25c36d20.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080916211934.25c36d20.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 16 Sep 2008 16:23:40 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> @@ -938,6 +1047,7 @@ static int mem_cgroup_force_empty(struct
>  	 * So, we have to do loop here until all lists are empty.
>  	 */
>  	while (mem->res.usage > 0) {
> +		drain_page_cgroup_all();

Shouldn't we wait here till the drain process completes?

>  		if (atomic_read(&mem->css.cgroup->count) > 0)
>  			goto out;
>  		for_each_node_state(node, N_POSSIBLE)
