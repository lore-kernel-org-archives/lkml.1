Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739Ab0A2ICr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0A2ICr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409Ab0A2ICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:02:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55349 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0A2ICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:02:45 -0500
Date: Fri, 29 Jan 2010 09:02:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       whalajam@yahoo.com
Subject: Re: Added in stricter no merge semantics for block I/O
Message-ID: <20100129080244.GF13771@kernel.dk>
References: <1264518884.3278.15.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264518884.3278.15.camel@cail>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26 2010, Alan D. Brunelle wrote:
> Added in stricter no merge semantics for block I/O
> 
> Updated 'nomerges' tunable to accept a value of '2' - indicating that _no_
> merges at all are to be attempted (not even the simple one-hit cache).
> 
> The following table illustrates the additional benefit - 5 minute runs of
> a random I/O load were applied to a dozen devices on a 16-way x86_64 system.
> 
> nomerges        Throughput      %System         Improvement (tput / %sys)
> --------        ------------    -----------     -------------------------
> 0               12.45 MB/sec    0.669365609
> 1               12.50 MB/sec    0.641519199     0.40% / 2.71%
> 2               12.52 MB/sec    0.639849750     0.56% / 2.96%
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> Cc: jens.axboe@oracle.com
> ---
>  Documentation/ABI/testing/sysfs-block |   14 ++++++++++++++
>  Documentation/block/queue-sysfs.txt   |   10 +++++-----
>  block/blk-sysfs.c                     |   11 +++++++----
>  block/elevator.c                      |   11 ++++++++++-
>  include/linux/blkdev.h                |    3 +++
>  5 files changed, 39 insertions(+), 10 deletions(-)

Thanks Alan, I think this is a good addition, I have often before hacked
up the "no merges at all" logic for testing purposes as well. I have
queued it up for 2.6.34.

-- 
Jens Axboe

