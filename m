Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZLRBS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZLRBS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZLRBS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:18:56 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:45069 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbZLRBSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nyD4aAx96dg2R5p+E/KEsh9Ktz4vE41K0iMEyNS6kgKX/sZpMc231STqaBUTzmYECN
         VyHTK6nSRSVlI5eJsARma4aVh24tb5Gw81921IMpuh02bEnMQkC4/PNoBUWnzDcGqkzZ
         irfoTzruuoLBSDAAelFcsDDx7TPe26RsaiNqk=
MIME-Version: 1.0
In-Reply-To: <1261047618.14314.6.camel@localhost>
References: <1261042383.14314.0.camel@localhost> <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com> 
	<20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
From: Jason Garrett-Glaser <darkshikari@gmail.com>
Date: Thu, 17 Dec 2009 17:18:28 -0800
Message-ID: <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
Subject: Re: x264 benchmarks BFS vs CFS
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 3:00 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
>> * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
>>
>> > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
>> > > well well :) nothing quite speaks out like graphs..
>> > >
>> > > http://doom10.org/index.php?topic=78.0
>> > >
>> > >
>> > >
>> > > regards,
>> > > Kasper Sandberg
>> >
>> > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied
>> > it--and given the strict thread-ordering expectations of x264, you basically
>> > can't expect it to do any better, though I'm curious what's responsible for
>> > the gap in "veryslow", even with SCHED_BATCH enabled.
>> >
>> > The most odd case is that of "ultrafast", in which CFS immediately ties BFS
>> > when we enable SCHED_BATCH.  We're doing some further testing to see exactly
>
> Thats kinda besides the point.
>
> all these tunables and weirdness is _NEVER_ going to work for people.

Can't individually applications request SCHED_BATCH?  Our plan was to
have x264 simply detect if it was necessary (once we figure out what
encoding settings result in the large gap situation) and automatically
enable it for the current application.

Jason
