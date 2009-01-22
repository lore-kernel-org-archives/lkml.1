Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZAVKVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZAVKVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZAVKVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:21:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZAVKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:21:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=qNKTWs4Gd9NDzMrnWqXH3UI/N/9Qq6Y43mEK/gpkVm/ZQBuP91c/zit7aTjgncmPC
	ukPorB7s3DbZdANASa2rA==
Date: Thu, 22 Jan 2009 02:18:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901221540.08108.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901220214450.2851@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901221453.14860.knikanth@suse.de> <alpine.DEB.2.00.0901220134200.32502@chino.kir.corp.google.com> <200901221540.08108.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Nikanth Karthikesan wrote:

> I think cpusets preference could be improved, not to depend on badness, with 
> something similar to what memcg does. With or without adding overhead of 
> tracking processes that has memory from a node.
> 

We actually used to do that: we excluded all tasks that did not share the 
same cpuset in select_bad_process().  That exclusion was reimplemented as 
a preference in badness() since, again, it is quite possible that a large 
memory-hogging task without a sufficient oom_adj score, as you mentioned, 
has allocated memory on the cpuset's nodes before being moved to a 
different cpuset or changing its set of allowable nodes.

I think you would find the per-cgroup oom notifier patch[*] of interest.  
It seems to have been dropped after some discussion on improvements, but 
allows you to defer all of these decisions to userspace.  Would something 
like that fix your problem?

 [*] http://marc.info/?l=linux-mm&m=122575082227252
