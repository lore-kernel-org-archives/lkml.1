Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZHCIIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZHCIIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZHCIIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:08:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZHCIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:08:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LjDVBH96Pedoan58N//01DN/VE112hNjzSsMBghsNIDw94KHCb4lc8iMZERrb3AAn
	Wkt2vJa3o9XeHttz6Ao/g==
Date: Mon, 3 Aug 2009 01:08:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090803170217.e98b2e46.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908030107110.30778@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com> <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com> <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com> <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
 <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com> <77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com> <20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com> <20090803170217.e98b2e46.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, KAMEZAWA Hiroyuki wrote:

> > You can't recalculate it if all the remaining threads have a different 
> > oom_adj value than the effective oom_adj value from the thread that is now 
> > exited.  
> 
> Then, crazy google apps pass different oom_adjs to each thread ?
> And, threads other than thread-group-leader modifies its oom_adj.
> 

Nope, but I'm afraid you've just made my point for me: it shows that 
oom_adj really isn't sanely used as a per-thread attribute and actually 
only represents a preference on oom killing a quantity of memory in all 
other cases other than vfork() -> change /proc/pid-of-child/oom_adj -> 
exec() for which we now appropriately have /proc/pid/oom_adj_child for.

Thanks.
