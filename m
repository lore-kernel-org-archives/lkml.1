Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZAMTq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZAMTq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZAMTqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:46:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZAMTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:46:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=vn6/IvpWz/aOk5unn/Gk3g1ehM4nqjXV7PdREIZE8Q/YSUOJfE/KHx6111LKDA3vp
	k0ZtsTL60q2uG0q/pP+Kw==
Date: Tue, 13 Jan 2009 11:46:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113152106.GA1134@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk>
 <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:

> Using oom_adj? Because there is no way I can determine which number to
> put there. It is not even documented for those who do not read kernel
> sources. Even after that: oom_score changes with time, and having 1/2 or
> 8 oom_adj is correct right now, it will not be in a few moments.
> 

Your oom_adj scores should never need to be changed unless you're tuning 
the inherited value of a child; it simply represents your input into when 
a specific task should be considered rogue enough to target.

However, patches to improve the documentation of the oom killer, or any 
other kernel feature, are always welcome.

> > You can replace the lines of kernel code you wrote with a simple
> > one-line script that Alan sent out.
> 
> Almost. But I can not if tasks are spawned from the parent process. We
> can not change the process to adjust its forked children to have
> different adjustment and can not change it for the process itself, since
> it should live and children should be dead.
> 

Children are already preferred over the chosen parent task, as I've 
explained a few times.  When a task is identified for oom kill by the 
badness heuristics, the oom killer attempts to kill a child that does not 
share the same mm first, which is exactly what you're asking for here.  If 
the parent shares the mm, it needs to exit as well before memory freeing 
may occur.
