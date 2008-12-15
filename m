Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYLOU31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYLOU31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYLOU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:29:19 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:56841 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYLOU3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xUt5PxtGU2MJ1TnPI4CH8XI5uNgx4gEyfvhcXewu35tRrJxBYS+8cdGxz6eFdSOsTe
         8LeqNK1G9LudCfKkBR6Hxl91KJ4BpCY1A2ylffH3d2cW4sABtocjhgtr3AoMi5FCyKy6
         EB07CiN7LI71GKhCWJq7swFW0EULaOCCA5Mgo=
Message-ID: <a4423d670812151229ua6f2d67u61ca5e13534fede8@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:29:17 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: next-20081215: kernel BUG at block/cfq-iosched.c:1243
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081215201836.GM32491@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670812151029u5458f9b4iaa36316a5f210ff1@mail.gmail.com>
	 <20081215183235.GG32491@kernel.dk>
	 <a4423d670812151038p4bab739fo3a6f9afd1ad3e358@mail.gmail.com>
	 <20081215184440.GI32491@kernel.dk>
	 <a4423d670812151209m7c0b6f99oc86dbc6d934fa084@mail.gmail.com>
	 <20081215201836.GM32491@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
> On Mon, Dec 15 2008, Alexander Beregalov wrote:
>> 2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
>> > On Mon, Dec 15 2008, Alexander Beregalov wrote:
>> >> 2008/12/15 Jens Axboe <jens.axboe@oracle.com>:
>> >> >> [   23.080733] kernel BUG at block/cfq-iosched.c:1243!
>> >> >> [   23.080733] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> >>
>> >> > Odd, is it reproducible? What is your .config?
>> >> Yes, it is
>> >>
>> >> Config is in attach
>> >
>> > It's weird, because the only change for CFQ in that area is the one
>> > below. Does the oops go away if you back this out?
>> Yes, it can boot without the patch, no oops.
>
> OK, dumb error. Please try this instead, on top of -next:
It works without oopses.
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 8a2485d..e8525fa 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1322,7 +1322,6 @@ static void cfq_exit_single_io_context(struct io_context *ioc,
>                smp_read_barrier_depends();
>                if (cic->key)
>                        __cfq_exit_single_io_context(cfqd, cic);
> -               __cfq_exit_single_io_context(cfqd, cic);
>
>                spin_unlock_irqrestore(q->queue_lock, flags);
>        }
>
> --
> Jens Axboe
>
>
