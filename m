Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbZLQKmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbZLQKmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZLQKmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:42:45 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:47317 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZLQKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:42:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gxoZaw5e7X1uJH968tBYQzLDHEmXTgBCqifOR1RToZ2COQvyv0izrtbgwaAjjsefSA
         b/kcjw8A/bufr/k6PzQRlk0YCVZAc4f6Vf7Vst0ZoncEGyx0jINgrUw2somv6UhNCeho
         6+4GFE00+2VE2gfy41h37mP3zvKdkszveHUEs=
MIME-Version: 1.0
In-Reply-To: <1261042383.14314.0.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Thu, 17 Dec 2009 02:42:24 -0800
Message-ID: <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
Subject: Re: x264 benchmarks BFS vs CFS
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> well well :) nothing quite speaks out like graphs..
>
> http://doom10.org/index.php?topic=78.0
>
>
>
> regards,
> Kasper Sandberg

Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically
tied it--and given the strict thread-ordering expectations of x264,
you basically can't expect it to do any better, though I'm curious
what's responsible for the gap in "veryslow", even with SCHED_BATCH
enabled.

The most odd case is that of "ultrafast", in which CFS immediately
ties BFS when we enable SCHED_BATCH.  We're doing some further testing
to see exactly what the conditions of this are--is it because
ultrafast is just so much faster than all the other modes and so
switches threads/loads faster?  Is it because ultrafast has relatively
equal workload among the threads, unlike the other loads?  We'll
probably know soon.

Jason
