Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZIVIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZIVIIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZIVIIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:08:17 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:60236 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZIVIIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:08:16 -0400
X-SourceIP: 213.93.53.227
Subject: Re: regression in page writeback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20090922080505.GB9192@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
	 <1253601612.8439.274.camel@twins>  <20090922080505.GB9192@localhost>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 10:09:25 +0200
Message-Id: <1253606965.8439.281.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> 
> I'm not sure how this patch stopped the "overshooting" behavior.
> Maybe it managed to not start the background pdflush, or the started
> pdflush thread exited because it found writeback is in progress by
> someone else?
> 
> -               if (bdi_nr_reclaimable) {
> +               if (bdi_nr_reclaimable > bdi_thresh) {

The idea is that we shouldn't move more pages from dirty -> writeback
when there's not actually that much dirty left.

Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
use bdi_thresh/2 a few times, but it generally didn't seem to make much
of a difference.



