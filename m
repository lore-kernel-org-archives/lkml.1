Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZL3VVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZL3VVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZL3VVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:21:10 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56091 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZL3VVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SfsKnoIn356n9K/rh9AumrdiB4HnMbbwsmtcd8//Ma4ROOzUUuNG3nRq3YhAvQdrKf
         YrxRseRFAPW1OOZlbHTpn0oByP53KrBxQIov8IBrs1cScrDJ3RxuAlUiKwwDT/np8UVs
         5ohlNmDZwRZeewJE5T5BZJLW1JLEJ6yoOAy1M=
MIME-Version: 1.0
In-Reply-To: <20091230211138.GN4489@kernel.dk>
References: <1262175004-2132-1-git-send-email-czoccolo@gmail.com>
	 <20091230184535.GE4489@kernel.dk>
	 <4e5e476b0912301231k3214bb3dicbfc59d94623d72@mail.gmail.com>
	 <20091230211138.GN4489@kernel.dk>
Date: Wed, 30 Dec 2009 22:21:08 +0100
Message-ID: <4e5e476b0912301321m7d6ab48dv58600b336b4a4cdd@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need queue merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 10:11 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Dec 30 2009, Corrado Zoccolo wrote:
>> On Wed, Dec 30, 2009 at 7:45 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Wed, Dec 30 2009, Corrado Zoccolo wrote:
>> >> Non rotational devices' performances are not affected by
>> >> distance of requests, so there is no point in having overhead
>> >> to merge queues of nearby requests.
>> >
>> > If the distance is zero, it may still make a big difference (at least
>> > for writes). This check would be better as "ncq and doesn't suck", ala
>> >
>> >        blk_queue_nonrot(q) && tagged
>> >
>> > like we do elsewhere.
>>
>> For reads, though, even flash cards and netbook ssds are completely
>> unaffected. I have done few experiments on my available disks:
>> * http://dl.dropbox.com/u/3525644/service_time.png (I used the
>> program: http://dl.dropbox.com/u/3525644/stride.c to get the graphs).
>
> Completely agree, it's writes that matter (as mentioned).
>
>> For distance 0, I think request merging will be more effective than
>> queue merging, moreover I think the multi-thread trick to have large
>
> Definitely true, but we don't allow cross cfqq merges to begin with.
>
>> I/O depth is used for reads, not writes (where simply issuing buffered
>> writes already achieves a similar effect), so I think it is safe to
>> disable it for all non-rotational devices.
>
> That still leaves direct writes. Granted it's a problem with a huge
> scope, but still.
Maybe I can mark sync queues that have write requests, and only add
those ones to the prio tree.
For writes, merging queues (and therefore requests) can probably help
even the smart ssds.

Thanks,
Corrado
>
> --
> Jens Axboe
>
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
