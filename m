Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYGRSgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYGRSgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYGRSgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:36:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:44292 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYGRSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:36:05 -0400
Date: Fri, 18 Jul 2008 22:35:50 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Message-ID: <20080718183549.GA23263@2ka.mipt.ru>
References: <200807171633.49791.opurdila@ixiacom.com> <200807182004.44664.opurdila@ixiacom.com> <20080718175341.GA21496@2ka.mipt.ru> <200807182116.43451.opurdila@ixiacom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807182116.43451.opurdila@ixiacom.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 09:16:43PM +0300, Octavian Purdila (opurdila@ixiacom.com) wrote:
> tcp_read_sock
>  ... -> skb_splice_bits -> spd_fill_page; 
>   on return (spd->nr_page is 1 and pipe->nrbufs is 1)
>  ... -> skb_splice_bits -> spd_fill_page; 
>   on return (spd->nr_page is 1 and pipe->nrbufs is 2)
>  ... -> skb_splice_bits -> spd_fill_page; 
>   on return (spd->nr_page is 1 and pipe->nrbufs is 3)
> ...
> 
> and so on until pipe->nrbufs is 16. At than point, we will block in pipe_wait, 
> inside splice_to_pipe.

Seems that SPLICE_F_NONBLOCK check should be propagated from
tcp_splice_read() into skb_splice_bits(), and this flag is actually
there already in tss.flags.

-- 
	Evgeniy Polyakov
