Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZK0IXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZK0IXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZK0IXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:23:12 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59489 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbZK0IXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:23:11 -0500
Date: Fri, 27 Nov 2009 09:23:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       mel@csn.ul.ie, efault@gmx.de
Subject: Re: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
Message-ID: <20091127082316.GY8742@kernel.dk>
References: <200911261710.40719.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911261710.40719.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26 2009, Corrado Zoccolo wrote:
> The introduction of ramp-up formula for async queue depths has
> slowed down dirty page reclaim, by reducing async write performance.
> This patch improves the formula by considering the remaining slice.
> 
> The new formula will allow more dispatches at the beginning of the
> slice, reducing them at the end.
> This will ensure that we achieve good throughput, without the risk of
> overrunning the allotted timeslice.
> 
> The threshold is automatically increased when sync I/O is not
> intermingled with async, in accordance with the previous incarnation of
> the formula.

The slow ramp up is pretty much essential to being able to have low
latency for the sync reads, so I'm afraid this will break that. I would
prefer doing it through memory reclaim detection, like the other patch
you and Motohiro suggested.

-- 
Jens Axboe

