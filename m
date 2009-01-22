Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZAVKBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZAVKBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbZAVKBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:01:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbZAVKBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:01:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=RSr+sMUKnXiaUE/JivLnwVjDjTjBHlyjBQHPllnDQL2Od4PcdFEudAVXrOtbcXWUl
	m8GbERNgHEBv7K/7Lg3iw==
Date: Thu, 22 Jan 2009 02:00:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Nikanth Karthikesan <knikanth@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090122095026.GA10579@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901220156310.1738@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901212054.34929.knikanth@suse.de> <alpine.DEB.2.00.0901211241040.21080@chino.kir.corp.google.com> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
 <20090122095026.GA10579@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.97
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Evgeniy Polyakov wrote:

> > For example, if your task triggers an oom as the result of its exclusive 
> > cpuset placement, the oom killer should prefer to kill a task within that 
> > cpuset to allow for future memory freeing.
> 
> This it not true for all cases. What if you do need to start this task
> and free something else outside the given set? This should be an
> administrative decision and not forced by the kernel. We used to have it
> that way, but it does not mean that it is the only correct way to do the
> things.
> 

In an exclusive cpuset, a task's memory is restricted to a set of mems 
that the administrator has designated.  If it is oom, the kernel must free 
memory on those nodes or the next allocation will again trigger an oom 
(leading to a needlessly killed task that was in a disjoint cpuset).

Really.

> > So, with your proposal, an administrator can specify the oom priority of 
> > an entire aggregate of tasks but the behavior may not be desired for a 
> > cpuset-constrained oom, while it may be perfectly legitimate for a global 
> > unconstrained oom.
> 
> In this case administrator will not do this. It is up to him to decide
> and not some inner kernel policy.
> 

Then the scope of this new cgroup is restricted to not being used with 
cpusets that could oom.
