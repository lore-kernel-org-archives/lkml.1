Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZG0SA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZG0SA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZG0SA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:00:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZG0SA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:00:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BqtHuT+o2UkMA1Qz3q5FdXeV/VhTQqo9gffTZfv4ogTpEpmiSo4Cpt9dy+Mnaeu2M
	UtR8Mi904C4sVUvLkenUw==
Date: Mon, 27 Jul 2009 11:00:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       y-goto@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <f39a7fd56408054bebd11e40b7dd4db6.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907271056170.8408@chino.kir.corp.google.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com> <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com> <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
 <20090724160936.a3b8ad29.akpm@linux-foundation.org> <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com> <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com> <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
 <2f11576a0907250621w3696fdc0pe61638c8c935c981@mail.gmail.com> <f39a7fd56408054bebd11e40b7dd4db6.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009, KAMEZAWA Hiroyuki wrote:

> This behavior itself is not very bad.
> And all hotplug thing is just a side story of this bugfix.
> 

Right, the original problem that Lee reported doesn't appear to be caused 
by hotplug.

> To update nodemask,  user's mask should be saved in the policy
> even when the mask is not relative and v.node should be calculated
> again, at event. IIUC, rather than per-policy update by notifer,
> some new implemenation for policy will be necessary.
> 

We don't need additional non-default mempolicy support for MEM_ONLINE.  
It would be inappropriate to store the user nodemask and then hot-add new 
nodes to mempolicies based on the given node id's when nothing is assumed 
of its proximity.  It's better left to userspace to update existing 
mempolicies to use the newly added memory.
