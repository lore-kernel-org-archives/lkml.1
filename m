Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZLKGej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZLKGej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZLKGej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:34:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37616 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbZLKGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:34:38 -0500
Message-ID: <4B21E806.6070207@cs.helsinki.fi>
Date: Fri, 11 Dec 2009 08:34:46 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing: Define kmem_trace_alloc_notrace unconditionally
References: <4B21DD88.7080806@cn.fujitsu.com> <4B21DF33.7010906@cs.helsinki.fi> <4B21E07B.9040301@cn.fujitsu.com>
In-Reply-To: <4B21E07B.9040301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan kirjoitti:
> Pekka Enberg wrote:
>> Li Zefan wrote:
>>> Always define kmem_trace_alloc_{,node}_notrace(), otherwise
>>> perf-kmem will show wrong stats ifndef CONFIG_KMEMTRACE,
>>> because a kmalloc() memory allocation may be traced by
>>> both trace_kmalloc() and trace_kmem_cache_alloc().
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Did you check how much this will make kernel text bigger because of the
>> inlining happening in kmem_cache_alloc_notrace()?
>>
> 
> I'm not sure I understood what you meant, but I'm not inlining
> kmem_cache_alloc_notrace(), and instead I'm removing the inline
> version in !CONFIG_KMEMTRACE case.

In SLUB, slab_alloc() will be inlined to kmem_cache_alloc_notrace() 
increasing mm/slub.o size so we don't want to define 
kmem_cache_alloc_notrace() unconditionally.

			Pekka
