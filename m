Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbYDAGZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbYDAGZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYDAGYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:24:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17385 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDAGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:24:54 -0400
Message-ID: <47F1D44A.8010908@yandex.ru>
Date: Tue, 01 Apr 2008 09:20:58 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>       <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>
In-Reply-To: <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 06:24:47.0632 (UTC) FILETIME=[155B1100:01C893C1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day Pekka

>>  +void *dbg_vmalloc(size_t size)
>>  +
>>  +void dbg_vfree(void *addr)
>>  +
>>  +void dbg_leak_report(void)
>
> Not acceptable for mainline kernel. SLAB already provides leak
> detection and it should be straight-forward to port over to SLUB too.

Yeah, we will remove this later, keep it for now because it is very
convenient. I guess you refer the /proc/slab_allocations feature.
We found it less appropriate because it needs additional scripts to
be run to detect leaks, while this simple just hack makes UBIFS print
a message if there is a leak, which is just easier for us.

>>  +/*
>>  + * struct eaten_memory - memory object eaten by UBIFS to cause memory pressure.
>>  + * @list: link in the list of eaten memory objects
>>  + * @pad: just pads to memory page size
>>  + */
>>  +struct eaten_memory {
>>  +       struct list_head list;
>>  +       uint8_t pad[PAGE_CACHE_SIZE - sizeof(struct list_head)];
>>  +};
>
> If you need this, please make it a standalone module in mm/.

That was introduced to test the UBIFS shrinker, and to make sure
there are no races and everything works fine. Yes, will be removed
later.

>>  +#ifdef CONFIG_UBIFS_FS_DEBUG
>>  +#define UBIFS_DBG(op) op
>>  +#define ubifs_assert(expr)  do {                                               \
>>  +
>>  +/* Generic debugging message */
>>  +#define dbg_msg(fmt, ...) do {                                                 \
>>  +
>>  +/* Debugging message which prints UBIFS key */
>>  +#define dbg_key(c, key, fmt, ...) do {                                         \
>>  +
>>  +#define dbg_err(fmt, ...) ubifs_err(fmt, ##__VA_ARGS__)
>>  +#define dbg_dump_stack() dump_stack()
>
> Please kill these wrappers and use BUG_ON, WARN_ON, and printk() where
> appropriate.

Well, I do not see a big reason not to get rid of this harmless stuff.
Many kernel subsystems have their debugging, why not? Using BUG_ON() is
OK in few most important places. But we want to have more assertions
which are compiled-out by default, why can't we?. Similar is for prints.

Thanks for the feed-back. 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
