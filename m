Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYEOSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYEOSKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYEOSKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:10:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62246 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYEOSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HyyMICcpFIK3+eQiDnLuLn3fflOROX9TjnK8/p3hRNGDmN9thOCHfMgtyEWIt+JmNtgKYVddbbne9QtTJB0H+Qk0EXvHCGb++Qp68jRfY1ffx9n3bsPXbq/k5YvPMoDEog9NALPactXU4CslACok+uYTIG+btC0YJ0m35FXn+Rc=
Date: Thu, 15 May 2008 20:09:14 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Kingsley Foreman <kingsley@internode.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080515180914.GA2936@ami.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C6040.9030808@trash.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:09:36PM +0200, Patrick McHardy wrote:
> Kingsley Foreman wrote:
>> i just rolled back the kernel to 2.6.24 and im seeing the same thing,
>>
>> I was using 2.6.22 before and didn't see the problem, txqueuelen on the 
>> bond0 interface is 0 (the default)
>
> That might explain things, although it shouldn't have worked before
> either.
>
> CBQ creates default pfifo qdiscs for its leaves, these use a limit
> of txqueuelen or 1 if it is zero. So even small bursts will cause
> drops. Do things improve if you set txqueuelen to a larger value
> *before* configuring the qdiscs?

Kingsley wrote to me that even after changing txqueuelen to 1000 the
"dropped" number didn't change much. A debugging patch with printks
around all "sch->qstats.dropps++" showed only the end of cbq_enqueue().
I've asked to check tomorrow "pfifo limit 1000" for these drops too.

> Another thing is that CBQ on bond will probably not work properly
> at all, it needs a real device since it measures the timing between
> dequeue events for idle time estimation. On software devices this
> doesn't work.

Right, but these drops without any sign of overactions or overlimits
seem to show it's not about shaping (or it's not counted/documented
enough).

Regards,
Jarek P.
