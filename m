Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0CILt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:49:28 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35931 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0CILtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:49:24 -0500
Message-ID: <4B9635BE.6090001@petalogix.com>
Date: Tue, 09 Mar 2010 12:49:18 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] fix sync_mm_rss in nommu (Was Re: sync_mm_rss()
 issues
References: <30859.1268056796@redhat.com> <20100309095830.7d4a744d.kamezawa.hiroyu@jp.fujitsu.com> <8bd0f97a1003081833s2e8527d7pd1e0b427ae76020@mail.gmail.com>
In-Reply-To: <8bd0f97a1003081833s2e8527d7pd1e0b427ae76020@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Mon, Mar 8, 2010 at 19:58, KAMEZAWA Hiroyuki wrote:
>> David-san, could you check this ?
>> ==
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Fix breakage in NOMMU build
>>
>> commit 34e55232e59f7b19050267a05ff1226e5cd122a5 added sync_mm_rss()
>> for syncing loosely accounted rss counters. It's for CONFIG_MMU but
>> sync_mm_rss is called even in NOMMU enviroment (kerne/exit.c, fs/exec.c).
>> Above commit doesn't handle it well.
>>
>> This patch changes
>>  SPLIT_RSS_COUNTING depends on SPLIT_PTLOCKS && CONFIG_MMU
>>
>> And for avoid unnecessary function calls, sync_mm_rss changed to be inlined
>> noop function in header file.
> 
> fixes Blackfin systems ...
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>


fixes Microblaze noMMU systems too.

Signed-off-by: Michal Simek <monstr@monstr.eu>

You can check Microblaze noMMU system via my site
http://www.monstr.eu/wiki/doku.php?id=log:log

Will be good to add your patches to linux-next before Linus tree.

Michal


> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
