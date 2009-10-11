Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbZJKCz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbZJKCz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 22:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbZJKCz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 22:55:26 -0400
Received: from verein.lst.de ([213.95.11.210]:34897 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbZJKCzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 22:55:25 -0400
Date: Sun, 11 Oct 2009 04:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: fweisbec@gmail.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: perf trace errors
Message-ID: <20091011025441.GA18152@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get some rather interesting errors using perf trace with the block
tracepoints on current mainline, e.g.:

perf record -f -e 'block:block_bio_queue:record' -R -F 1 -a -s
<do some disk I/O end then ctrl+c>
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.237 MB perf.data (~10362 samples) ]

brick:/home/hch# perf trace
  Fatal: unknown op '-'
          xfssyncd-4232  [000]    87.798249255: block_bio_queue: 253,

There are lots of occurances of that exactly same warning in
builtin-trace.c, and the code sourrouning them is sufficiently enough
convoluted that I'm not able to track it down.
