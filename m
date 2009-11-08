Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZKHQQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZKHQQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZKHQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:16:16 -0500
Received: from [95.166.99.235] ([95.166.99.235]:43086 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZKHQQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:16:16 -0500
Date: Sun, 8 Nov 2009 17:16:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: fix next_rq computation
Message-ID: <20091108161620.GM8742@kernel.dk>
References: <200911072237.01807.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911072237.01807.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07 2009, Corrado Zoccolo wrote:
> Cfq has a bug in computation of next_rq, that affects transition
> between multiple sequential request streams in a single queue
> (e.g.: two sequential buffered writers of the same priority),
> causing the alternation between the two streams for a transient period.
> 
>   8,0    1    18737     0.260400660  5312  D   W 141653311 + 256
>   8,0    1    20839     0.273239461  5400  D   W 141653567 + 256
>   8,0    1    20841     0.276343885  5394  D   W 142803919 + 256
>   8,0    1    20843     0.279490878  5394  D   W 141668927 + 256
>   8,0    1    20845     0.292459993  5400  D   W 142804175 + 256
>   8,0    1    20847     0.295537247  5400  D   W 141668671 + 256
>   8,0    1    20849     0.298656337  5400  D   W 142804431 + 256
>   8,0    1    20851     0.311481148  5394  D   W 141668415 + 256
>   8,0    1    20853     0.314421305  5394  D   W 142804687 + 256
>   8,0    1    20855     0.318960112  5400  D   W 142804943 + 256
> 
> The fix makes sure that the next_rq is computed from the last
> dispatched request, and not affected by merging.
> 
>   8,0    1    37776     4.305161306     0  D   W 141738087 + 256
>   8,0    1    37778     4.308298091     0  D   W 141738343 + 256
>   8,0    1    37780     4.312885190     0  D   W 141738599 + 256
>   8,0    1    37782     4.315933291     0  D   W 141738855 + 256
>   8,0    1    37784     4.319064459     0  D   W 141739111 + 256
>   8,0    1    37786     4.331918431  5672  D   W 142803007 + 256
>   8,0    1    37788     4.334930332  5672  D   W 142803263 + 256
>   8,0    1    37790     4.337902723  5672  D   W 142803519 + 256
>   8,0    1    37792     4.342359774  5672  D   W 142803775 + 256
>   8,0    1    37794     4.345318286     0  D   W 142804031 + 256

Thanks, this is a nice patch! I will apply it to for-2.6.33. Can I added
your signed-off-by?

-- 
Jens Axboe

