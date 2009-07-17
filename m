Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbZGQJBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbZGQJBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZGQJBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:01:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241AbZGQJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:01:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hiCWFgXPcclwgw28YSU98Zymve21qgI39HWnYLSDDsOoaPH8Xl1qCsMBDHwbpaYbL
	Ludy1mru1TW2i2v5dP6LQ==
Date: Fri, 17 Jul 2009 02:01:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
In-Reply-To: <20090717090003.A903.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907170158050.13151@chino.kir.corp.google.com>
References: <1247679064.4089.26.camel@useless.americas.hpqcorp.net> <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com> <20090717090003.A903.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, KOSAKI Motohiro wrote:

> This patch seems band-aid patch. it will change memory-hotplug behavior.
> Please imazine following scenario:
> 
> 1. numactl interleave=all process-A
> 2. memory hot-add
> 
> before 2.6.30:
> 		-> process-A can use hot-added memory
> 

That apparently depends on the architecture since Lee said top_cpuset 
reflects node_possible_map on ia64 and node_online_map on x86_64.
