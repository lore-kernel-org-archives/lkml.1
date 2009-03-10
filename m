Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZCJWM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZCJWM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZCJWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:12:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZCJWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:12:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xpTbu6r4SUKEeDVEIyilU9HQaK3PLHdx+pjUBRAZhQklXSPdBlwE+E6hVKZVPnyx4
	lLUb50/5tRPfKINkbx5Hw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903101649330.20363@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
	 <20090309181756.CF66.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903091706540.1861@qirst.com>
	 <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0903101649330.20363@qirst.com>
Date: Tue, 10 Mar 2009 15:12:07 -0700
Message-ID: <6599ad830903101512g16a8eda3w959123e71c225960@mail.gmail.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Paul Menage <menage@google.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 1:50 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
>
> So no real workload just some isolation idea.

We definitely  have real workloads where a job is allocating lots of
slab memory (e.g. network socket buffers, dentry/inode objects, etc)
and we want to be able to account the memory usage to each job rather
than having all the slab scattered around unidentifiably, and to
reduce fragmentation (so when a job finishes, all its sockets close
and all its files are deleted, there's a better chance that we'll be
able to reclaim some slab memory). We could probably turn those into
more synthetic benchmarkable loads if necessary for demonstration.

Paul
