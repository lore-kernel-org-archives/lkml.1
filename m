Return-Path: <linux-kernel-owner+w=401wt.eu-S966054AbZLHUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054AbZLHUql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZLHUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:46:35 -0500
Received: from mail-yw0-f196.google.com ([209.85.211.196]:64865 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZLHUqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c9U1EL08dip0JgknZkJHtrMrFT4sHxo2Mmbrn83xAu11g+uJN1yk7sDXza8+vEjgl/
         aDUxMRSPjNt/iGZWfvzYrG6OMp5KLIHn5g6Q9z6tyUkDjS309WbhuG1KeczvOhqS6BOF
         J6j7Nv5N0zwKFrMaVbxbfDcRFZSU1Xe7yKsIo=
MIME-Version: 1.0
In-Reply-To: <x49hbs1fir5.fsf@segfault.boston.devel.redhat.com>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	 <x49hbs1fir5.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 8 Dec 2009 21:46:39 +0100
Message-ID: <4e5e476b0912081246w32a9ae1bw7d49b0285719b22e@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Tue, Dec 8, 2009 at 7:00 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> The introduction of ramp-up formula for async queue depths has
>> slowed down dirty page reclaim, by reducing async write performance.
>> This patch makes sure the formula kicks in only when sync request
>> was recently delayed.
>> @@ -3706,7 +3707,7 @@ static void *cfq_init_queue(struct request_queue *q)
>>       cfqd->cfq_latency = 1;
>>       cfqd->cfq_group_isolation = 0;
>>       cfqd->hw_tag = -1;
>> -     cfqd->last_end_sync_rq = jiffies;
>> +     cfqd->last_delayed_sync = jiffies - HZ;
>
> So, umm, what's that about?

Previously, when cfq started, it started in a state where writes were
completely throttled. Now, we optimistically prefer to start with a
reasonable max depth (10)

Thanks
Corrado

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
