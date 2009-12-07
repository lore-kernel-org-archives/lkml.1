Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZLGSV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZLGSV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZLGSVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:21:55 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:50018 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbZLGSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:21:55 -0500
Message-ID: <4B1D47C5.7030804@pardus.org.tr>
Date: Mon, 07 Dec 2009 20:21:57 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: CCISS performance drop in buffered disk reads in newer kernels
References: <4B1CDCE6.5040502@pardus.org.tr> <0F5B06BAB751E047AB5C87D1F77A778869941207A5@GVW0547EXC.americas.hpqcorp.net>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778869941207A5@GVW0547EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miller, Mike (OS Dev) wrote:
> Ozan,
> I'm aware of the performance drop. Please see: http://bugzilla.kernel.org/show_bug.cgi?id=13127. I removed the huge read ahead value of 1024 that we used because users were complaining about small writes being starved. That was back around the 2.6.25 timeframe. Since that timeframe there have no changes in the main i/o path. I'll get back on this as time allows.
>
> Meanwhile, you can tweak some of the block layer tunables as such.
>
>     echo 64 > /sys/block/cciss\!c0d1/queue/read_ahead_kb
> OR
>     blockdev --setra 128 /dev/cciss/c0d1
>
> These are just example values. There is also max_hw_sectors_kb and max_sectors_kb that be adjusted.
>   

Hi,

Actually the "#define READ_AHEAD 1024" was removed on March 2008 which
was included in the 2.6.25.y tree so 2.6.25.20 has 128kB read_ahead
value too.

*But* setting read_ahead to 2048 increases buffered disk read average
from 60~MB/s to 190~MB/s hence the kernel compile time drops to 2 minutes.

So maybe the regression/change is in another place?

The server is just a compile-farm so it's triggered by hand, compiles
distribution's packages and stays idle until the next compilation queue.
Is it safe/OK to use that 2048kB read_ahead value for such workload?

(max_hw_sectors_kb is 512 on my 2.6.25.20 setup and 1024 on 2.6.30.9 but
it seems that it's read-only)

Thanks!
