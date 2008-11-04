Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKDPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKDPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYKDPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:02:07 -0500
Received: from smtp02.zero.jp ([210.157.5.232]:43889 "EHLO smtp.zero.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753134AbYKDPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:02:06 -0500
X-Spam-Flag: NO
X-Spam-Score: 2.412
Message-ID: <491063E5.9060805@ct.jp.nec.com>
Date: Tue, 04 Nov 2008 10:01:57 -0500
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nikanth Karthikesan <KNikanth@novell.com>
CC: nikanth@gmail.com, agk@redhat.com, j-nomura@ce.jp.nec.com,
       "<Andi Kleen" <andi@firstfloor.org>,
       James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com,
       dm-devel@redhat.com, "<Milan Broz" <mbroz@redhat.com>, knikanth@suse.de,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [dm-devel] [PATCH 10/13] dm: add core functions for request-based
 dm
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com> <20080912.104612.115643090.k-ueda@ct.jp.nec.com> <807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com> <490FB852.3FEE.00C5.1@novell.com> <49102C03020000C50002E257@victor.provo.novell.com>
In-Reply-To: <49102C03020000C50002E257@victor.provo.novell.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

Nikanth Karthikesan wrote:
> Hi Kiyoshi
> 
>>>> On 10/28/2008 at 09:30 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote: 
>> Hi Nikanth,
>>
>> On Fri, 24 Oct 2008 13:14:50 +0530, "Nikanth K" wrote:
>>> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
>>> <snip>
>>>
>>>> +static int dm_make_request(struct request_queue *q, struct bio *bio)
>>>> +{
>>>> +       struct mapped_device *md = (struct mapped_device *)q->queuedata;
>>>> +
>>>> +       if (unlikely(bio_barrier(bio))) {
>>>> +               bio_endio(bio, -EOPNOTSUPP);
>>>> +               return 0;
>>>> +       }
>>>> +
>>> <snip>
>>>
>>> Why not add barrier support in the beginning itself, so that targets
>>> can be developed with barriers in mind? At least can we make the target
>>> to return error, instead of the core?
>> Currently, there is no barrier support in dm, not only request-based.
>> Barrier support is a different feature in the next step, I think.
> 
> But there are some works in that direction to add support for barriers in dm.
> That is why I think building request-based dm with barriers from the 
> ground up might be a good idea.

I agree, if I or other people have a time to implement barrier support
for request-based dm.
But I think the some works you mentioned above are:
    - Andi Kleen: barrier support for linear (single device)
    - Milan Broz: full barrier support in dm core (no target patch)
so there is no barrier support work for dm-multipath yet.

Current request-based target is only dm-multipath, so we won't have
any feature regression even if request-based dm-multipath gets in.
And I don't have much time to implement barrier support for
request-based dm-multipath now, so I'd like to consider it as
the next step.

Thanks,
Kiyoshi Ueda
