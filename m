Return-Path: <linux-kernel-owner+w=401wt.eu-S1423238AbXDYG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423238AbXDYG71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423241AbXDYG71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:59:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45970 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423238AbXDYG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:59:26 -0400
Date: Wed, 25 Apr 2007 08:58:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vasily Tarasov <vtaras@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, OVZDL <devel@openvz.org>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Message-ID: <20070425065822.GG9715@kernel.dk>
References: <1177422791.435404.4031.nullmailer@me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177422791.435404.4031.nullmailer@me>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, Vasily Tarasov wrote:
> @@ -1806,7 +1765,11 @@ static int cfq_may_queue(request_queue_t
>  	 * so just lookup a possibly existing queue, or return 'may queue'
>  	 * if that fails
>  	 */
> -	cfqq = cfq_find_cfq_hash(cfqd, key, tsk->ioprio);
> +	cic = cfq_get_io_context_noalloc(cfqd, tsk);
> +	if (!cic)
> +		return ELV_MQUEUE_MAY; 
> +
> +	cfqq = cic->cfqq[rw & REQ_RW_SYNC];
>  	if (cfqq) {
>  		cfq_init_prio_data(cfqq);
>  		cfq_prio_boost(cfqq);

Ahem, how well did you test this patch?

-- 
Jens Axboe

