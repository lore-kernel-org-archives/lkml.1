Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZKCUeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZKCUeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZKCUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:34:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZKCUeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:34:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oqY6VGeC+kejrdW4vYiqfn2Ivf90v3FiXZHQqtFlw6J1X1a7RWKEVTUKYkZtIwwh4
	r0a5peKZ8+8Sd2kPxf8DA==
Date: Tue, 3 Nov 2009 12:34:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 0/6] oom-killer: total renewal
In-Reply-To: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911031229590.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Hi, as discussed in "Memory overcommit" threads, I started rewrite.
> 
> This is just for showing "I started" (not just chating or sleeping ;)
> 
> All implemtations are not fixed yet. So feel free to do any comments.
> This set is for minimum change set, I think. Some more rich functions
> can be implemented based on this.
> 
> All patches are against "mm-of-the-moment snapshot 2009-11-01-10-01"
> 
> Patches are organized as
> 
> (1) pass oom-killer more information, classification and fix mempolicy case.
> (2) counting swap usage
> (3) counting lowmem usage
> (4) fork bomb detector/killer
> (5) check expansion of total_vm
> (6) rewrite __badness().
> 
> passed small tests on x86-64 boxes.
> 

Thanks for looking into improving the oom killer!

I think it would be easier to merge the four different concepts you have 
here:

 - counting for swap usage (patch 2),

 - oom killer constraint reorganization (patches 1 and 3),

 - fork bomb detector (patch 4), and 

 - heuristic changes (patches 5 and 6)

into seperate patchsets and get them merged one at a time.  I think patch 
2 can easily be merged into -mm now, and patches 1 and 3 could be merged 
after cleaned up.  We'll probably need more discussion on the rest.

Patches 1 and 6 have whitespace damage, btw.
