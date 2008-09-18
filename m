Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYIRU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYIRU5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYIRU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:57:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:1063 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYIRU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=byvq+n6OdZTT+JCzzLT1cf3tcDZN7RornhPBOsNz83A976Zx6th5Y+bluIGQa9Fvhy
         wb01TrcxxwOyOQbooXZ3kXkpn58CQ4bbe+wO7iF7pm3wA2p5XqYYt4v/VadYp9Fjyp/e
         3DuAHERYd0+7ag5Cx89H/HTSUd3zkrkhkULH4=
Message-ID: <48D2C0A2.4070203@gmail.com>
Date: Thu, 18 Sep 2008 22:57:06 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] memrlimit: fix task_lock() recursive locking
References: <48D29485.5010900@gmail.com> <48D2A21E.7050806@linux.vnet.ibm.com> <48D2B69D.8080404@gmail.com>
In-Reply-To: <48D2B69D.8080404@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
>  static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct cgroup *old_cgrp,
> @@ -246,9 +246,9 @@ static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>  						struct task_struct *p)
>  {
>  	struct memrlimit_cgroup *memrcg, *old_memrcg;
> -	struct mm_struct *mm = get_task_mm(p);
> +	struct mm_struct *mm = p->mm;
>  
> -	BUG_ON(!mm);
> +	BUG_ON(!mm || (p->flags & PF_KTHREAD));
>  
>  	/*
>  	 * If we don't have a new cgroup, we just uncharge from the old one.

My bad! mmput() must be removed at the end of this function! (just hit
another bug).

Ignore this one and sorry for the noise. I'll send a new patch.

-Andrea
