Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZDNDMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZDNDMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZDNDMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:12:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZDNDMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:12:40 -0400
Message-ID: <49E3FF53.6010205@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 11:13:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
References: <49E31931.5000506@cn.fujitsu.com> <20090413180054.GZ5178@kernel.dk>
In-Reply-To: <20090413180054.GZ5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Apr 13 2009, Li Zefan wrote:
>> Impact: allow ftrace-plugin blktrace to trace device-mapper devices
>>
>> blktrace can't trace a single partition, so it makes no sense to
>> have one trace/ dir in each /sys/block/sda/sdaX. Move it to
>> /sys/block/sda/.
>>
>> Thus we fix an issue reported by Ted, that ftrace-plugin blktrace
>> can't be used to trace device-mapper devices.
> 
> Perhaps I never committed that patch, but it would be trivial to do
> partition based blktrace tracing. It's also quite useful. So please
> don't go changing things to make that harder to support, it would be
> nicer to just add the (small) bits to support per-partition tracing.
> It's basically just a start/stop sector range, while some events are
> per-device and should just be included always.
> 

Ok, I found that patch in btrace mailing list. I'll rebase it and
send it out.

How about just add trace/ to /sys/block/sda? Then if we want to trace
the whole sda, we can:
  # echo 1 > /sys/block/sda/enable
If we want to trace a single partition:
  # echo 1 > /sys/block/sda/sda1/enable

Like "btrace /dev/sda" and "btrace /dev/sda1" when using userspace blktrace.

And when this is done, tracing device-mapper is supported, and I think
current md devices can't be traced by ftrace-plugin blktrace too.

--
Zefan
