Return-Path: <linux-kernel-owner+w=401wt.eu-S965746AbZLHSAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746AbZLHSAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 13:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965736AbZLHSAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 13:00:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbZLHSAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 13:00:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 08 Dec 2009 13:00:46 -0500
In-Reply-To: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com> (Corrado
	Zoccolo's message of "Fri, 4 Dec 2009 13:35:05 +0100")
Message-ID: <x49hbs1fir5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> The introduction of ramp-up formula for async queue depths has
> slowed down dirty page reclaim, by reducing async write performance.
> This patch makes sure the formula kicks in only when sync request
> was recently delayed.
> @@ -3706,7 +3707,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_latency = 1;
>  	cfqd->cfq_group_isolation = 0;
>  	cfqd->hw_tag = -1;
> -	cfqd->last_end_sync_rq = jiffies;
> +	cfqd->last_delayed_sync = jiffies - HZ;

So, umm, what's that about?

Cheers,
Jeff
