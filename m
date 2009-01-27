Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZA0Jix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZA0Jix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZA0Jio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:38:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59481 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZA0Jin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:38:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=SV9JfgsI3KszQi+SFpeQKTHRSSUy7FFB4TygN/iJVLQ0dcjFf5UGNAelXSWVL18z7
	IMQHx+MnePQ3twOE4o9Iw==
Date: Tue, 27 Jan 2009 01:37:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090127093105.GB2646@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901270134360.20070@chino.kir.corp.google.com>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com>
 <20090127093105.GB2646@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Evgeniy Polyakov wrote:

> /dev/mem_notify is a great idea, but please do not limit existing
> oom-killer in its ability to do the job and do not rely on application's
> ability to send a SIGKILL which will not kill tasks in unkillable state
> contrary to oom-killer.
> 

You're missing the point, /dev/mem_notify would notify userspace of lowmem 
situations and allow it to respond appropriately in any number of ways 
before an oom condition exists.

When the system (or cpuset, memory controller, etc) is oom, userspace can 
choose to defer to the oom killer so that it may kill a task that would 
most likely lead to future memory freeing with access to memory reserves.

There is no additional oom killer limitation imposed here, nor can the oom 
killer kill a task hung in D state any better than userspace.

Thanks.
