Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbZFKDY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbZFKDY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZFKDYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:24:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZFKDYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:24:21 -0400
Message-ID: <4A30793C.6090208@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 11:25:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
References: <20090610195311.767699959@goodmis.org> <20090610195524.945549278@goodmis.org> <4A305A1A.2010901@cn.fujitsu.com> <alpine.DEB.2.00.0906102200180.30552@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906102200180.30552@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 11 Jun 2009, Lai Jiangshan wrote:
> 
>>> -	list_splice(&pages, head);
>>> +	/*
>>> +	 * The ring buffer page list is a circular list that does not
>>> +	 * start and end with a list head. All page list items point to
>>> +	 * other pages. Remove one of the pages, init its list head,
>>> +	 * and use list splice to move the rest of the pages to it.
>>> +	 */
>>> +	bpage = list_entry(pages.next, struct buffer_page, list);
>>> +	list_del_init(&bpage->list);
>>> +	cpu_buffer->pages = &bpage->list;
>>> +
>>> +	list_splice(&pages, cpu_buffer->pages);
>>> +
>> Is it proper?
>>
>> 	cpu_buffer->pages = pages.next;
>> 	list_del(&pages);
>>
> 
> Not sure what you are asking here?
> 


I'm not sure whether these 4 lines:
	bpage = list_entry(pages.next, struct buffer_page, list);
	list_del_init(&bpage->list);
	cpu_buffer->pages = &bpage->list;

	list_splice(&pages, cpu_buffer->pages);
equal to these 2 lines:
 	cpu_buffer->pages = pages.next;
 	list_del(&pages);

If there are equivalent, I think the second one
are simpler. It may be not a really necessarily cleanup.

What I asked is: if there are equivalent, could you use these two line:
 	cpu_buffer->pages = pages.next;
 	list_del(&pages);

Lai.

