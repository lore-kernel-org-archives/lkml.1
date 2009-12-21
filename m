Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZLUJKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZLUJKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZLUJKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:10:32 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49543 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZLUJKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:10:31 -0500
Date: Mon, 21 Dec 2009 10:10:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC]block: add a new flag to make request complete on
	submitted  cpu
Message-ID: <20091221091030.GF4489@kernel.dk>
References: <20091221022827.GA1897@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221022827.GA1897@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21 2009, Shaohua Li wrote:
> We already have a QUEUE_FLAG_SAME_COMP, which makes request complete
> on the first cpu of a mc/ht, but this isn't sufficient. In a system
> with fast block devices (intel SSD), it turns out the first cpu is
> bottlenect. Add a flag to make request complete on cpu where request
> is submitted. The flag implies QUEUE_FLAG_SAME_COMP. By default, it is off.

It was a lazy trick to avoid doing any round robin work in there.

> My test machine has two CPUs and 4 intel SSD. Without the new flag,
> the io thoughput is about 400m/s; with it, the thoughput is about 500m/s.

So I think we should just fix it, I still think the group logic makes
sense. But instead of always going for the first one, let it complete
locally if part of the group, if not send to specific submitter CPU.

-- 
Jens Axboe

