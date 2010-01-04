Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802Ab0ADShV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0ADShV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785Ab0ADShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:37:20 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58239 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0ADShT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DVbFmTKPCuU2WXXYtH6KnwEgFz3C0sYDzMoeXFQw4x00fREFJGOMbwZuob2whN1awt
         Y9oXLjsEq201QDeJPj/PqylH+vzOGpG25JsuME2FJl15GO69BDvunn8KNsiJB7WtKA+y
         Ku4LBtzxp/UQsY4LQSTL2Qj2PKsCTEXfdACtU=
MIME-Version: 1.0
In-Reply-To: <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
References: <20091230213439.GQ4489@kernel.dk>
	 <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	 <20100104144711.GA7968@redhat.com>
	 <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	 <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 4 Jan 2010 19:37:17 +0100
Message-ID: <4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue 
	merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 5:51 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Hi Vivkek,
>>
>> On Mon, Jan 4, 2010 at 3:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Wed, Dec 30, 2009 at 11:22:47PM +0100, Corrado Zoccolo wrote:
>>>> Non rotational devices' performances are not affected by
>>>> distance of read requests, so there is no point in having
>>>> overhead to merge such queues.
>>>> This doesn't apply to writes, so this patch changes the
>>>> queued[] field, to be indexed by READ/WRITE instead of
>>>> SYNC/ASYNC, and only compute proximity for queues with
>>>> WRITE requests.
>>>>
>>>
>>> Hi Corrado,
>>>
>>> What's the reason that reads don't benefit from merging queues and hence
>>> merging requests and only writes do on SSD?
>>
>> On SSDs, reads are just limited by the maximum transfer rate, and
>> larger (i.e. merged) reads will just take proportionally longer.
>
> This is simply not true.  You can get more bandwidth from an SSD (I just
> checked numbers for 2 vendors' devices) by issuing larger read requests,
> no matter whether the access pattern is sequential or random.
I know, but the performance increase given the size is sublinear, and
the situation here is slightly different.
In order for the requests to be merged, they have to be submitted concurrently.
So you have to compare 2 concurrent requests of size x with one
request of size 2*x (with some CPU overhead).
Moreover, you always pay the CPU overhead, even if you can't do the
merging, and you must be very lucky to keep merging, because it means
the two processes are working in lockstep; it is not sufficient that
the requests are just nearby, as for rotational disks.

Thanks,
Corrado

>
> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
