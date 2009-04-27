Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZD0MPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZD0MPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZD0MPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:15:34 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44790 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752169AbZD0MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:15:33 -0400
Date: Mon, 27 Apr 2009 21:15:33 +0900 (JST)
Message-Id: <20090427.211533.115916003.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: randy.dunlap@oracle.com, menage@google.com, chlunde@ping.uio.no,
       eric.rannaud@gmail.com, balbir@linux.vnet.ibm.com,
       fernando@oss.ntt.co.jp, dradford@bluehost.com, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [PATCH 1/9] io-throttle documentation
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090427.194533.183037823.ryov@valinux.co.jp>
References: <20090420.183815.226804723.ryov@valinux.co.jp>
	<20090420150052.GC13307@linux>
	<20090427.194533.183037823.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa-san,

> I've come up with an idea to coexist blkio-cgroup and io-throttle.
> blkio-cgroup provides a function to get a cgroup with the specified ID.
> 
> /* Should be called under rcu_read_lock() */
> struct cgroup *blkio_cgroup_lookup(int id)
> {
> 	struct cgroup *cgrp;
> 	struct cgroup_subsys_state *css;
> 	
> 	if (blkio_cgroup_disabled())
> 		return NULL;
> 
> 	css = css_lookup(&blkio_cgroup_subsys, id);
> 	if (!css)
> 		return NULL;
> 	cgrp = css->cgroup;
> 	return cgrp;
> }
> 
> Then io-throttle can get a struct iothrottle which belongs to the
> cgroup by using the above function.
> 
> static struct iothrottle *iothrottle_lookup(int id)
> {
> 	struct cgroup *grp;
> 	struct iothrottle *iot;
> 
> 	...
> 	grp = blkio_cgroup_lookup(id);
> 	if (!grp)
> 		return NULL
> 	iot = cgroup_to_iothrottle(grp);
> 	...
> }
> 
> What do you think about this way?

I have some questions. 
- How about using the same numbering scheme as process ID for css_id
  instead of idr? It prevents the same ID from being resued quickly.
- Why are css_ids assigned per css? If each cgroup has a unique ID and
  the subsystems can refer to it, I can make the above code simple.

Thanks,
Ryo Tsuruta
