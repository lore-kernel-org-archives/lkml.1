Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZKFPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZKFPT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZKFPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:19:26 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:34684 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbZKFPTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pRP+0OXiUDRRy59sO7u5EhnsyhCANJVRJacx93D/gjRUAtB+cGbwJQVSdD3fzLnQhV
         kHz+6rs6Vo/yznUO9jDGUBb2IJ/JMavZyw+YAfg6swW4R7EzNhXXXeHbqdrux76sIxXZ
         BeTGJ2fU2QbSW/ucbTnDzfGOmEooXp6XmgycI=
MIME-Version: 1.0
In-Reply-To: <20091106134030.a94665d1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360911050711k47a63896xe4915157664cb822@mail.gmail.com>
	 <20091106084806.7503b165.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091106134030.a94665d1.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 7 Nov 2009 00:19:30 +0900
Message-ID: <28c262360911060719y45f4b58ex2f13853f0d142656@mail.gmail.com>
Subject: Re: [PATCH] show per-process swap usage via procfs v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       cl@linux-foundation.org, akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 1:40 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> RSS usage is important information but one more information which
> is often asked by users is "usage of swap".(user support team said.)
>
> This patch counts swap entry usage per process and show it via
> /proc/<pid>/status. I think status file is robust against new entry.
> Then, it is the first candidate..
>
>  After this, /proc/<pid>/status includes following line
>  <snip>
>  VmPeak:   315360 kB
>  VmSize:   315360 kB
>  VmLck:         0 kB
>  VmHWM:    180452 kB
>  VmRSS:    180452 kB
>  VmData:   311624 kB
>  VmStk:        84 kB
>  VmExe:         4 kB
>  VmLib:      1568 kB
>  VmPTE:       640 kB
>  VmSwap:   131240 kB <=== new information
>
> Note:
>  Because this patch catches swap_pte on page table, this will
>  not catch shmem's swapout. It's already accounted in per-shmem
>  inode and we don't need to do more.
>
> Changelog: 2009/11/06
>  - fixed bad use of is_migration_entry. Now, non_swap_entry() is used.
> Changelog: 2009/11/03
>  - clean up.
>  - fixed initialization bug at fork (init_mm())
>
> Acked-by: Acked-by; David Rientjes <rientjes@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
