Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZLKGCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZLKGCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZLKGCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:02:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZLKGCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:02:50 -0500
Message-ID: <4B21E07B.9040301@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 14:02:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 1/2] tracing: Define kmem_trace_alloc_notrace unconditionally
References: <4B21DD88.7080806@cn.fujitsu.com> <4B21DF33.7010906@cs.helsinki.fi>
In-Reply-To: <4B21DF33.7010906@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Li Zefan wrote:
>> Always define kmem_trace_alloc_{,node}_notrace(), otherwise
>> perf-kmem will show wrong stats ifndef CONFIG_KMEMTRACE,
>> because a kmalloc() memory allocation may be traced by
>> both trace_kmalloc() and trace_kmem_cache_alloc().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Did you check how much this will make kernel text bigger because of the
> inlining happening in kmem_cache_alloc_notrace()?
> 

I'm not sure I understood what you meant, but I'm not inlining
kmem_cache_alloc_notrace(), and instead I'm removing the inline
version in !CONFIG_KMEMTRACE case.

