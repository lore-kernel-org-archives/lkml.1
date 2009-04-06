Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZDFNE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZDFNE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZDFNER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:04:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59639 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZDFNEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:04:16 -0400
Date: Mon, 6 Apr 2009 15:04:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406130414.GX5178@kernel.dk>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06 2009, Jens Axboe wrote:
> Hi,
> 
> This is a set of patches that I worked on today in the hopes
> of furthering the latency goals and at least fixing some of
> the write regression with fwrite + fsync that current -git
> is suffering from.
> 
> I haven't done any latency tests yet, I'm just tossing this
> out there so we can collaborate on improving things. What I
> did test was the silly fwrite() + fsync() loop test, which
> is a LOT slower in current -git that it used to be. The test
> is basically:
> 
> 	while (nr--) {
> 		f = fopen();
> 		fprintf(f, "Some data here\n");
> 		fsync(fileno(f));
> 		fclose(f);
> 	}
> 
> which (for nr == 2000) takes 16 seconds in -git, completes
> in 0.9s with the patches.

Ran the fsync-tester [1]. Drive is a 3-4 years old SATA drive, fs is
ext3/writeback. IO scheduler is CFQ.

fsync time: 0.0402s
fsync time: 0.6572s
fsync time: 0.3187s
fsync time: 0.2901s
fsync time: 0.1478s
fsync time: 0.4158s
fsync time: 0.2815s
fsync time: 0.3216s
fsync time: 0.1604s
fsync time: 0.1929s
fsync time: 0.2413s
fsync time: 0.2138s
fsync time: 0.2441s
fsync time: 0.2785s
fsync time: 0.2640s

And with Linus torture dd running in the background:

fsync time: 0.0109s
fsync time: 0.5236s
fsync time: 1.2108s
fsync time: 0.2999s
fsync time: 1.5286s
fsync time: 0.2549s
fsync time: 0.4164s
fsync time: 1.1586s
fsync time: 1.6630s
fsync time: 0.6949s
fsync time: 1.0102s
fsync time: 0.3715s
fsync time: 0.6553s

[1]
http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=33847;list=linux

-- 
Jens Axboe

