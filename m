Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0BVVWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:22:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0BVVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:21:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vDivxPT1JKA7Gkbai8LJ+iX4vuK8E45FvbM/NLW6tZZbYA4IVqfUQtkogjkDkoOwn
	6U6T9M8iBHErx/x7vWzPw==
Date: Mon, 22 Feb 2010 13:21:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <arighi@develer.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
In-Reply-To: <20100222180013.GB4052@linux>
Message-ID: <alpine.DEB.2.00.1002221319170.14426@chino.kir.corp.google.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-2-git-send-email-arighi@develer.com> <20100222092242.98df82e4.kamezawa.hiroyu@jp.fujitsu.com> <20100222180013.GB4052@linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Andrea Righi wrote:

> > Hmm...do we need spinlock ? You use "unsigned long", then, read-write
> > is always atomic if not read-modify-write.
> 
> I think I simply copy&paste the memcg->swappiness case. But I agree,
> read-write should be atomic.
> 

We don't need memcg->reclaim_param_lock in get_swappiness() or
mem_cgroup_get_reclaim_priority().
