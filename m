Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbXLRK71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbXLRK71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbXLRK7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:59:00 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:59042 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbXLRK67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:58:59 -0500
Date: Tue, 18 Dec 2007 11:58:50 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: swapping in 2.6.24-rc5-git3
Message-ID: <20071218105850.GA4249@ics.muni.cz>
References: <20071217131726.GA14091@ics.muni.cz> <20071217171532.GK6979@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071217171532.GK6979@atrey.karlin.mff.cuni.cz>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 18 Dec 2007 11:58:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 06:15:32PM +0100, Jan Kara wrote:
>   I think yes. 0 swappiness doesn't mean "no swapping at all". From the
> code in shrink_active_list() it seems that it just decreases likeliness
> of removing pages of mmaped files (i.e., also executables loaded in memory).

So, I tried to add some prints. 

I have mapped ratio about 78 while scp-ing the file. Distress suddenly raises
from 0 to 100. At this poing, all the processes are swapped out.

I guess it happens if scp is faster than the local disk which happens if
I scp-ing over GE from desktop (with fast disk - and reading) to laptop (slow
disk - and writing).

This is my settings.
/proc/sys/vm/*
block_dump:0
dirty_background_ratio:10
dirty_expire_centisecs:2999
dirty_ratio:40
dirty_writeback_centisecs:499
drop_caches:0
laptop_mode:0
legacy_va_layout:0
lowmem_reserve_ratio:256	256	32
max_map_count:65536
min_free_kbytes:4006
nr_pdflush_threads:2
oom_kill_allocating_task:0
overcommit_memory:0
overcommit_ratio:50
page-cluster:3
panic_on_oom:0
percpu_pagelist_fraction:0
stat_interval:1
swappiness:0
vfs_cache_pressure:100

-- 
Luká¹ Hejtmánek
