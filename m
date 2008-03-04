Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYCDIKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYCDIKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYCDIKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:10:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:52192 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYCDIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:10:09 -0500
Message-ID: <47CD03DE.3010703@suse.de>
Date: Tue, 04 Mar 2008 09:10:06 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       michaelc@cs.wisc.edu
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>	<47CC2652.1080601@suse.de> <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
In-Reply-To: <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> Hi Hannes,
> 
> On Mon, 03 Mar 2008 17:24:50 +0100, Hannes Reinecke wrote:
>> Hi Kiyoshi,
>>
>> Kiyoshi Ueda wrote:
>>> This patch adds ->complete_io() hook for request stacking.
>>> Request stacking drivers (such as request-based dm) can set
>>> a callback for completion.
>>> (The hook is not called in blk_end_io(), since request-based dm uses
>>>  it for clone completion in the following appendix patches.)
>>>
>> [ .. ]
>> I would rather have rq->complete_io() to be pointing to blk_end_io in the
>> default case, this way rq->complete_io() would always be valid and we
>> would be saving us the if() clause.
> 
> Thank you for the comment.
> 
> I'm thinking about an idea come from Mike and Jens after the session
> at LSF'08:
>   o stacking driver clones both bio and request and uses
>     bio->bi_end_io and rq->end_io
>   o stacking driver uses blk_complete_request() in rq->end_io
>     so that stacking driver can work without queue lock
> With this idea, we don't need to add the new hook to request,
> and we can use request stacking on drivers using __blk_end_request().
> 
Huh? I can't really imagine how this should work. If you start using
bio->bi_end_io() for stacking usage you'll end up with doing weird thing
with the bios ... Can you elaborate a bit more here?

> Currently, I'm trying to convert request-based dm to use the idea above.
> I'll post the new version as a RFC in the near future.
> 
Oh, cool. Looking forward to it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
