Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYLaWiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYLaWiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYLaWiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:38:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30772 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLaWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:38:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jpnOZ/gESE5wFMt6o/BtghNsGT3KgFtgi7Evj/OyY07zVQAgnUK4Tx8AbmGB8IK0vU
         xpkbfxNge+E1S/i85cZkVz+9SZ+/+nFf7ZrDhAsrqTTO5SOpPuHadlj+frO/9gs82JIC
         bgZMGyjNS+EHlriJ+BVJZri8bv72qbuokhkaw=
Message-ID: <b637ec0b0812311438h44b45697p62954ea52a0a7d9a@mail.gmail.com>
Date: Wed, 31 Dec 2008 23:38:01 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Jayson King" <dev@jaysonking.com>
Subject: Re: large intermittent latency spike 2.6.28 (and 2.6.27.10), bisect commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 -> Revert "sched_clock: prevent scd->clock from moving backwards"
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       shaggy@linux.vnet.ibm.com, rjw@sisk.pl
In-Reply-To: <495BF1BD.1070408@jaysonking.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495A96FF.1000200@jaysonking.com> <495BF1BD.1070408@jaysonking.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The revert you did was rejected in the 2.6.28 timeframe becaused it
caused a regression on my laptop. The patch Ingo suggested (originally
from Thomas Gleixner) addresses both your issue and mine.

Regards,
Fabio

On Wed, Dec 31, 2008 at 11:27 PM, Jayson King <dev@jaysonking.com> wrote:
> Arjan van de Ven wrote:
>> Jayson King <dev@jaysonking.com> wrote:
>>> Please disregard this. ...
>>
>> can you run latencytop to see if it can pinpoint a cause of latency?
>
> Like I said in my other reply I was running the wrong kernel when I wrote
> that (oops)... So now I am still sure it is ca7e716.
>
> Ingo's patch makes the same change that reverting ca7e716 does here:
>
> -       max_clock = scd->tick_gtod + TICK_NSEC;
> +       max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
>
>
> And with that change (I'm using Ingo's patch now) I can't trigger the hang
> anymore. And before, I could reliably trigger it in a short time.
>
> Jayson
>
>
