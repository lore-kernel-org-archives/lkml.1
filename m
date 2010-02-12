Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0BLRvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:51:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46404 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab0BLRve convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:51:34 -0500
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
References: <4B71927D.6030607@nortel.com>
	<20100210093140.12D9.A69D9226@jp.fujitsu.com>
	<4B72E74C.9040001@nortel.com>
	<28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>
	<4B74524D.8080804@nortel.com>
	<28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Feb 2010 17:50:31 +0000
In-Reply-To: <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> (Minchan Kim's message of "Fri\, 12 Feb 2010 11\:38\:12 +0900")
Message-ID: <tnxk4ui9wd4.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Feb 2010 17:50:34.0142 (UTC) FILETIME=[E04FBBE0:01CAAC0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan.kim@gmail.com> wrote:
> On Fri, Feb 12, 2010 at 3:54 AM, Chris Friesen <cfriesen@nortel.com> wrote:
>> I have a modified version of that which I picked up as part of the
>> kmemleak backport.  However, it doesn't help unless I can narrow down
>> *which* pages I should care about.
>
> kmemleak doesn't support page allocator and ioremap.
> Above URL patch just can tell who requests page which is using(ie, not
> free) now.

The ioremap can be easily tracked by kmemleak (it is on my to-do list
but haven't managed to do it yet). That's not far from vmalloc.

The page allocator is a bit more difficult since it's used by the slab
allocator as well and it may lead to some recursive calls into
kmemleak. I'll have a think.

Anyway, you can leak memory without this being detected by kmemleak -
just add the allocated objects to a list and never remove them.

-- 
Catalin
