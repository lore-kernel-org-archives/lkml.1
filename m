Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYEOSsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYEOSsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYEOSr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:47:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1083 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYEOSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mHAk1a3sJo8Rk2X4ftNM0pd3yNgU+M5lZtbLH6yZSryG/vXVeSc9mX/wzqPRZdINawnMo1FDsPdTST0AkA0urg/Gcwq4U/6qJOYiCafKXzIceJ0C0wjrS54PMTRwPII0NekrW3Qi2n+86XLQat9ea3SsiHRipaFt3Z0cJF5B1kI=
Date: Thu, 15 May 2008 20:46:46 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Kingsley Foreman <kingsley@internode.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080515184646.GC2936@ami.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local> <482C81CC.7000305@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C81CC.7000305@trash.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 08:32:44PM +0200, Patrick McHardy wrote:
> Jarek Poplawski wrote:
>> On Thu, May 15, 2008 at 06:09:36PM +0200, Patrick McHardy wrote:
>> ...
>>> Do things improve if you set txqueuelen to a larger value
>>> *before* configuring the qdiscs?
>>
>> BTW, I hope it was *before*, but since pfifo_fast_enqueue() uses
>> "qdisc->dev->tx_queue_len" does it really matter? (Until it's
>> before the test of course...)
>
>
> Yes, CBQ uses pfifo, not pfifo_fast. pfifo uses txqueuelen
> to inialize q->limit, but thats whats used during ->enqueue().

...My bad! I missed this and this (only!?) seems to explain this
puzzle. So, I hope it was really because *not before* (and not only
size matters...)

Thanks,
Jarek P.
