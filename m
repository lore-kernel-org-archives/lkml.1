Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZJZSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZJZSD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZJZSDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:03:25 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50673 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZJZSDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q1ROZKVvD65ZkeyruXIjr6E0MgZ/QcPHFzCtvLvrlPyV/U9IaPIEGdZoX5Kj2qgLE0
         tr110BMh4AnsPCqV9v7LJI8u5WriZLXIDcxBgEuGImQMB56IBKSooai4tcyNjTmnanJu
         O2MoRYMsb2Tl7P4yBEQr8Ppq7Tj30wJo/ZgiA=
MIME-Version: 1.0
In-Reply-To: <x49k4yixiox.fsf@segfault.boston.devel.redhat.com>
References: <200910202012.43338.czoccolo@gmail.com>
	 <x49k4yixiox.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 26 Oct 2009 19:03:28 +0100
Message-ID: <4e5e476b0910261103g3dee483fic19e8713ed52ac3e@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 5/5] cfq-iosched: fairness for sync no-idle queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 4:45 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> +static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
>> +{
>> +     if (!cfq_cfqq_sync(cfqq))
>> +             return ASYNC_WORKLOAD;
>> +     if (CFQQ_SEEKY(cfqq) || !cfq_cfqq_idle_window(cfqq))
>> +             return SYNC_NOIDLE_WORKLOAD;
>> +     return SYNC_WORKLOAD;
>> +}
>
> The calculation to determine whether or not to idle is now done in at
> least 2 places.  Perhaps it's time for a helper function.

Maybe that CFQQ_SEEKY(cfqq) test can just be removed, and we just rely
on the idle flag set by cfq_update_idle_window (it is already testing
seekiness there, but it also considers number of samples).
I'll do some testing without it to see if it changes anything.

>
> There are some other coding style nits, but I'll let Jens comment on
> those.  I think the idea looks good.  Once you rebase I'll run some
> tests; this is some really good work!
>
Thanks. Testing on different hardware is always appreciated.

Cheers,
Corrado
> Cheers,
> Jeff
>
