Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYDCPp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYDCPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbYDCPpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:45:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbYDCPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:45:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UbiQeiLzDiiI80ax6RCz3XpuTWAYNDDWSn02PiH40IOO/qYG7Yic3/wuJiSTZNZMG
	fwYGrafCSXU+geliesNlA==
Message-ID: <6599ad830804030845m71d56d88u3508a252fc134ba5@mail.gmail.com>
Date: Thu, 3 Apr 2008 08:45:33 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v6)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403073043.3563.63717.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403073043.3563.63717.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 12:30 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  +         This option enables mm_struct's to have an owner. The advantage
>  +         of this approach is that it allows for several independent memory
>  +         based cgorup controllers to co-exist independently without too

cgorup -> cgroup

>  +       if (need_mm_owner_callback) {
>  +               int i;
>  +               for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  +                       struct cgroup_subsys *ss = subsys[i];
>  +                       oldcgrp = task_cgroup(old, ss->subsys_id);
>  +                       newcgrp = task_cgroup(new, ss->subsys_id);
>  +                       if (oldcgrp == newcgrp)
>  +                               continue;
>  +                       if (ss->mm_owner_changed)
>  +                               ss->mm_owner_changed(ss, oldcgrp, newcgrp);

Even better, maybe just pass in the relevant cgroup_subsys_state
objects here, rather than the cgroup objects?

>
>         css_get(&mem->css);
>  -       rcu_assign_pointer(mm->mem_cgroup, mem);
>         css_put(&old_mem->css);

These get/put calls are now unwanted?

Could you also add comments in mm_need_new_owner(), in particular the
reason for checking for delay_group_leader() ?

Paul
