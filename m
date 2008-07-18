Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYGRSp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYGRSp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbYGRSpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:45:46 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:1565 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbYGRSpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:45:45 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: IXIA
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] tcp: do not promote SPLICE_F_NONBLOCK to socket O_NONBLOCK
Date: Fri, 18 Jul 2008 21:43:38 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <200807171633.49791.opurdila@ixiacom.com> <200807182116.43451.opurdila@ixiacom.com> <20080718183549.GA23263@2ka.mipt.ru>
In-Reply-To: <20080718183549.GA23263@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807182143.38624.opurdila@ixiacom.com>
X-OriginalArrivalTime: 18 Jul 2008 18:47:41.0548 (UTC) FILETIME=[C217E2C0:01C8E906]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2008, Evgeniy Polyakov wrote:

> >
> > and so on until pipe->nrbufs is 16. At than point, we will block in
> > pipe_wait, inside splice_to_pipe.
>
> Seems that SPLICE_F_NONBLOCK check should be propagated from
> tcp_splice_read() into skb_splice_bits(), and this flag is actually
> there already in tss.flags.

I'm not sure I understand you... 

The flag gets propagated to splice_to_pipe (so there is no need to propagate 
the check in skb_splice_bits) but we don't have SPLICE_F_NONBLOCK set, we are 
on the blocking usecase.

Thanks,
tavi
