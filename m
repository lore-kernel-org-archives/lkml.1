Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYFFNuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYFFNuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYFFNuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:50:13 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:40655 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbYFFNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:50:12 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Denys Fedoryshchenko" <denys@visp.net.lb>, linux-kernel@vger.kernel.org
Subject: Re: strange timestamp in dmesg
From: Andi Kleen <andi@firstfloor.org>
References: <20080605115256.M13181@visp.net.lb>
	<20080606031939.285679c9.akpm@linux-foundation.org>
Date: Fri, 06 Jun 2008 15:49:26 +0200
In-Reply-To: <20080606031939.285679c9.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 6 Jun 2008 03:19:39 -0700")
Message-ID: <87hcc6u109.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jun 2008 13:42:16.0935 (UTC) FILETIME=[226C5770:01C8C7DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> supports DPO and FUA
>> [    9.801761] sd 1:0:1:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
>> [    9.673388] sd 1:0:1:0: [sdc] Write Protect is off
>> [    9.673395] sd 1:0:1:0: [sdc] Mode Sense: ab 00 10 08
>> [    9.806210] sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled,
>> supports DPO and FUA
>> [    9.806220]  sdc: sdc1
>> [    9.682136] sd 1:0:1:0: [sdc] Attached SCSI disk
>> [   13.786405] SGI XFS with large block numbers, no debug enabled
>> [   13.633457] XFS mounting filesystem sdb2
>> [   13.724345] Starting XFS recovery on filesystem: sdb2 (logdev: internal)
>> [   14.251356] Ending XFS recovery on filesystem: sdb2 (logdev: internal)
>> [   15.379298] XFS mounting filesystem sdc1
>> [   15.468255] Starting XFS recovery on filesystem: sdc1 (logdev: internal)
>> [   14.514314] Ending XFS recovery on filesystem: sdc1 (logdev: internal)
>> [   14.767260] warning: `squid' uses 32-bit capabilities (legacy support in use)
>> [   17.589751] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full
>> Duplex, Flow Control: RX/TX
>> 
>
> whoa, that's weird.  We've seen timestamps jump forward a single hop of
> ~100000 seconds, but that's all over the place.

No it's expected since printk uses sched_clock() and sched clock is not synchronous
between CPUs on systems without synchronized/invariant TSC (like Opteron)
All sched_clock() users are expected to handle it.

I always advocated just always using jiffies for printk. The only drawback would
be that it won't increase in interrupt off sections, but if you have
one that is longer than a jiffie then you have enough other problems.

-Andi
