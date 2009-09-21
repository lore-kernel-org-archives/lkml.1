Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZIUCgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZIUCgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 22:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZIUCgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 22:36:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZIUCgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 22:36:11 -0400
Message-ID: <4AB6E651.6050000@cn.fujitsu.com>
Date: Mon, 21 Sep 2009 10:34:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/events: use list_for_entry_continue
References: <4AB32364.7020602@cn.fujitsu.com> <4AB32389.1030005@cn.fujitsu.com> <20090918150930.GB5200@nowhere>
In-Reply-To: <20090918150930.GB5200@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Sep 18, 2009 at 02:07:05PM +0800, Li Zefan wrote:
>> Simplify s_next() and t_next().
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
> 
> Nice.
> I wonder if that can be even more simplified with
> the following existing seq helpers:
> 

Unfortunately they can't be used here, at least they can't
help make code simpler, because we need to skip some list
entries.

But we can add seq_list_start_at() and seq_list_next_at(),
which take a predicate and will return an entry which matches
the predicate. I thought about it, and I can try it out.

> extern struct list_head *seq_list_start(struct list_head *head,
> 		loff_t pos);
> extern struct list_head *seq_list_start_head(struct list_head *head,
> 		loff_t pos);
> extern struct list_head *seq_list_next(void *v, struct list_head *head,
> 		loff_t *ppos);
> 
