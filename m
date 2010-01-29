Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754Ab0A2VLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0A2VLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0A2VLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:11:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0A2VLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:11:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GVoB8UZzSk0zqDMsA/XBxEDEyWzFgbJwGSY04qRqGk+6fyM0fIASdE4y1u4vqstHD
	D9xobiLBEj8FM92cgLE6g==
Date: Fri, 29 Jan 2010 13:11:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, vedran.furac@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001291307460.2938@chino.kir.corp.google.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com> <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk> <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010, KAMEZAWA Hiroyuki wrote:

> If so, all heuristics other than vm_size should be purged, I think.

I don't recall anybody disagreeing about removing some of the current 
heuristics, but there is value to those beyond simply total_vm: we want to 
penalize tasks that do not share any mems_allowed with the triggering 
task, for example, otherwise it can lead to needless oom killing.  Many 
people believe we should keep the slight penalty for superuser tasks over 
regular user tasks, as well.

Auditing the badness() function is a worthwhile endeavor and I think you'd 
be most successful if you tweaked the various penalties (runtime, nice, 
capabilities, etc) to reflect how much each is valued in terms of VM size, 
the baseline.  I doubt anybody would defend simply dividing by 4 or 
multiplying by 2 being scientific.
