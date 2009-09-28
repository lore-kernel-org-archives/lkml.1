Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZI1Ceo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZI1Ceo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 22:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZI1Ceo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 22:34:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38446 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZI1Cen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 22:34:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Sep 2009 11:32:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wrong Vmalloc numbers in /proc/meminfo
Message-Id: <20090928113222.ae0f49c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200909280209.32457.elendil@planet.nl>
References: <200909280209.32457.elendil@planet.nl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 02:09:30 +0200
Frans Pop <elendil@planet.nl> wrote:

> With 2.6.31 (on x86_64) I'm seeing the following in /proc/meminfo.
> 
> $ cat /proc/meminfo
> MemTotal:        2030968 kB
> MemFree:          539408 kB
> Buffers:           94984 kB
> Cached:           308564 kB
> SwapCached:        16048 kB
> Active:           652236 kB
> Inactive:         428808 kB
> Active(anon):     436808 kB
> Inactive(anon):   246996 kB
> Active(file):     215428 kB
> Inactive(file):   181812 kB
> Unevictable:        1632 kB
> Mlocked:            1632 kB
> SwapTotal:       2097144 kB
> SwapFree:        1979524 kB
> Dirty:                12 kB
> Writeback:             0 kB
> AnonPages:        671276 kB
> Mapped:            57684 kB
> Slab:             177692 kB
> SReclaimable:     160516 kB
> SUnreclaim:        17176 kB
> PageTables:        14812 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     3112628 kB
> Committed_AS:     988780 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      340084 kB
> VmallocChunk:   34359387131 kB
> DirectMap4k:     2008768 kB
> DirectMap2M:       63488 kB
> 
> Is it me or are VmallocTotal and VmallocChunk off by a factor 10,000 or so?
> 
I'm sorry I misunderstand your 10,000 implies.

On my x86-64 box.
VmallocTotal:   34359738367 kB
VmallocUsed:      100856 kB
VmallocChunk:   34359583863 kB

Then,
34359738367 - 34359583863
154504

Then difference is 13412 (pages) 

Hmm. in /proc/vmallocinfo
==
..
0xffffc9000652b000-0xffffc9000672c000 2101248 sys_swapon+0x6a2/0xcd0 pages=512 vmalloc N0=512
0xffffc90007efd000-0xffffc90008dde000 15601664 pcpu_alloc+0x3ad/0x4e0 vmalloc
0xffffc900096d9000-0xffffc900096dd000   16384 e1000e_setup_tx_resources+0x39/0xe0 [e1000e] pages=3 vmalloc N0=3
0xffffc900096de000-0xffffc900096e2000   16384 e1000e_setup_rx_resources+0x37/0x160 [e1000e] pages=3 vmalloc N0=3
==

It seems some amount of memory holes (rather than PAGESIZE) between vmalloc area
info.(especially around pcpu_alloc..) please check /proc/vmallocinfo if you
feel something strange.


Thanks,
-Kame


> Cheers,
> FJP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

