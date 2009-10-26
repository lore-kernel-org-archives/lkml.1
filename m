Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZJZPO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZJZPO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZJZPO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:14:56 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:62471 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZJZPOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tuKGD3Md25O2zPJDyDTijb9uFCICCsoBqsIDiBSOUpJMu2BeXZly6DKkQm5zSyBVyi
         6WH3pyKz5j0VqLsgQxiDo8AlYLh4An5Askv6wEfxIVQw3IA6f1lpKCBrzQa0uwSNd8I6
         pz+rDJw/KKfDUo2tPMWO2YQOATPdQMiwfElSw=
MIME-Version: 1.0
In-Reply-To: <x49ws2ixkbq.fsf@segfault.boston.devel.redhat.com>
References: <200910202011.53858.czoccolo@gmail.com>
	 <x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910210932l2dffdabdv67a449ca162efd0f@mail.gmail.com>
	 <x49tyxs7lge.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910220343q2af96eedr69cda2594822af76@mail.gmail.com>
	 <x49ws2ixkbq.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 26 Oct 2009 16:14:57 +0100
Message-ID: <4e5e476b0910260814n93aa9e9p981ece92d0bf51f@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of 
	processes doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 4:10 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>> What about:
>> /* interested queues (we consider only the ones with the same priority class) */
>> unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
>> unsigned sync_slice = cfqd->cfq_slice[1];
>> unsigned expected_latency = sync_slice * iq;
>> if (expected_latency > target_latency) {
>>       unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
>>       /* scale low_slice according to IO priority and sync vs async */
>>       unsigned low_slice = min(slice,  base_low_slice * slice / sync_slice);
>>       /* the adapted slice value is scaled to fit all iqs into the target latency */
>>       slice = max(slice * cfq_target_latency / expected_latency, low_slice);
>> }
>
> Yeah, that looks a ton better.  Thanks for doing that!

Jens, if you like the new version of the code (integrating this last
change), I can rebase my patch set on top of Jeff's, since it is
already queued for 2.6.33 .

Corrado

>
> Cheers,
> Jeff
>
