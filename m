Return-Path: <linux-kernel-owner+w=401wt.eu-S2992531AbXDYJy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992531AbXDYJy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXDYJy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:54:57 -0400
Received: from wasp.net.au ([203.190.192.17]:48358 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992531AbXDYJy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:54:56 -0400
Message-ID: <462F2568.8010108@wasp.net.au>
Date: Wed, 25 Apr 2007 13:54:48 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com>	<17956.22235.574867.179016@notabene.brown>	<20070418123757.GC3796@kernel.dk>	<46261ACE.1050407@wasp.net.au>	<20070418132157.GC3720@kernel.dk>	<462B10C3.1030906@wasp.net.au>	<20070423073543.GE5311@kernel.dk>	<462E5D38.5000801@wasp.net.au>	<17967.4734.783140.512857@notabene.brown>	<20070425084607.GM9715@kernel.dk> <17967.8536.788076.851546@notabene.brown>
In-Reply-To: <17967.8536.788076.851546@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Wednesday April 25, jens.axboe@oracle.com wrote:
>> BUT... That may explain while we are only seeing it on md. Would md
>> ever be issuing such requests that trigger this condition?
> 
> Can someone remind me which raid level(s) was/were involved?

Raid-5 gegraded here, But I've had it on my server on a fully functioning raid-5 also. Don't think 
I've seen it on any of my raid-6 yet.

> I guess it could happen with raid4/5/6.  A read request that was
> properly aligned (and we do encourage proper alignment) will be passed
> directly to the underlying device.  A concurrent write elsewhere could
> require the same block to be read into the stripe-cache to enable a
> parity calculation.  So you could get two reads at the same block
> address.

Except all the filesystems I've had this occur on are Ext3 and all are mounted noatime, with no 
processes ever writing to the filesystems. So here it occurs with reads only.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
