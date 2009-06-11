Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbZFKDf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbZFKDf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZFKDfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:35:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZFKDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:35:15 -0400
Date: Wed, 10 Jun 2009 23:35:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] ring-buffer: make the buffer a true circular link
 list
In-Reply-To: <4A30793C.6090208@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906102332390.30552@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org> <20090610195524.945549278@goodmis.org> <4A305A1A.2010901@cn.fujitsu.com> <alpine.DEB.2.00.0906102200180.30552@gandalf.stny.rr.com> <4A30793C.6090208@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Jun 2009, Lai Jiangshan wrote:
> 
> I'm not sure whether these 4 lines:
> 	bpage = list_entry(pages.next, struct buffer_page, list);
> 	list_del_init(&bpage->list);
> 	cpu_buffer->pages = &bpage->list;
> 
> 	list_splice(&pages, cpu_buffer->pages);

> equal to these 2 lines:
>  	cpu_buffer->pages = pages.next;
>  	list_del(&pages);
> 
> If there are equivalent, I think the second one
> are simpler. It may be not a really necessarily cleanup.
> 
> What I asked is: if there are equivalent, could you use these two line:
>  	cpu_buffer->pages = pages.next;
>  	list_del(&pages);

OK, now I understand.

Hmm, that may be so. I'll have to look deeper at that.

Thanks,

-- Steve

