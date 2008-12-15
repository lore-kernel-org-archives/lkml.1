Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYLOK5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYLOK5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYLOK5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:57:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYLOK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:57:04 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.28-rc8 big regression in VM
Cc: kosaki.motohiro@jp.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081215095311.GB4422@ics.muni.cz>
References: <20081215110231.00DF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081215095311.GB4422@ics.muni.cz>
Message-Id: <20081215193305.06C4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 15 Dec 2008 19:56:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 15, 2008 at 11:05:24AM +0900, KOSAKI Motohiro wrote:
> > I also don't reproduce your problem.
> > Could you get output of "cat /proc/meminfo", not only free command?
> 
> attached meminfo and vmstat after dropping caches.


MemTotal:        2016688 kB
MemFree:         1528748 kB
Buffers:             424 kB
Cached:           140060 kB
SwapCached:            0 kB
Active(anon):     329884 kB
Inactive(anon):        4 kB
Active(file):      23368 kB
Inactive(file):    47328 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1542232 kB
SwapFree:        1542232 kB
Dirty:                64 kB
Writeback:             0 kB
AnonPages:        260100 kB
Mapped:            85036 kB


Usually, Cached - tmpfs ~= Active(file) + Inactive(file).
tmpfs file isn't droppable.

We should see Active(file) + Inactive(file) (= 70696kB) instead Cached.
In addition, drop_cache sysctl can't drop Mapped memory.

Then, this value isn't so wonder value, IMHO.




