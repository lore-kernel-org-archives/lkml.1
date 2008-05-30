Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYE3Gqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYE3Gqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYE3Gqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:46:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38903 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYE3Gqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:46:44 -0400
Date: Fri, 30 May 2008 15:51:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080530155141.a87fa316.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0805292313240.12457@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
	<20080529222143.5d7aa1e5.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
	<20080529224959.3297a4f1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292313240.12457@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 23:16:11 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 29 May 2008, Andrew Morton wrote:
> 
> > > No. The module subsystem has its own alloc_percpu subsystem that the 
> > > cpu_alloc replaces.
> > 
> > That is to support DEFINE_PER_CPU, not alloc_percpu().
> 
> Right but it needs to have its own section of the percpu space from which 
> it allocates the percpu segments for the modules. So it effectively 
> implements an allocator.
> 

Could you add a text to explain "This interface is for wise use of
pre-allocated limited area (see Documentation/xxxx). please use this only
when you need very fast access to per-cpu object and you can estimate the amount
which you finally need. If unsure, please use generic allocator."

for the moment ?

At first look, I thought of using this in memory-resource-controller but it seems
I shouldn't do so because thousands of cgroup can be used in theory...

Thanks,
-Kame


