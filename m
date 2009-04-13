Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZDMSBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZDMSBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZDMSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:00:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50282 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbZDMSAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:00:55 -0400
Date: Mon, 13 Apr 2009 20:00:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
Message-ID: <20090413180054.GZ5178@kernel.dk>
References: <49E31931.5000506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E31931.5000506@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13 2009, Li Zefan wrote:
> Impact: allow ftrace-plugin blktrace to trace device-mapper devices
> 
> blktrace can't trace a single partition, so it makes no sense to
> have one trace/ dir in each /sys/block/sda/sdaX. Move it to
> /sys/block/sda/.
> 
> Thus we fix an issue reported by Ted, that ftrace-plugin blktrace
> can't be used to trace device-mapper devices.

Perhaps I never committed that patch, but it would be trivial to do
partition based blktrace tracing. It's also quite useful. So please
don't go changing things to make that harder to support, it would be
nicer to just add the (small) bits to support per-partition tracing.
It's basically just a start/stop sector range, while some events are
per-device and should just be included always.

-- 
Jens Axboe

