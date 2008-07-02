Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYGBPG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYGBPG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGBPGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:06:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33441 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYGBPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:06:50 -0400
Message-ID: <486B9987.8000601@firstfloor.org>
Date: Wed, 02 Jul 2008 17:06:47 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>	<486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[again with correct ccs sorry]

Vitaly Mayatskikh wrote:
> > Andi Kleen <andi@firstfloor.org> writes:
> >
>> >> get/put user are macros and it's normally not a good idea to use ++ in macro
>> >> arguments because they might expand multiple times.
>> >>
>> >> sizeof(char) is always 1
>> >>
>> >> Also hopefully there's no sign extension anywhere with the signed char
> >
> > I have tested it a lot. I don't know of any fail scenario at the moment.
> >
>> >> Overall you could write it much simpler with a rep ; movs I think,
>> >> like traditional linux did.
> >
> > rep movs can fail.

How? (if it's a byte copy?)

The old 2.4 copy_*_user always used to that and it worked just fine AFAIK.


>> >> Similar problem with ++
>> >>
>> >> If zerorest is ever 0 then retesting it on every iteration seems
>> >> somewhat dumb.
> >
> > If zerorest is 0, this cycle will never be executed.

Ok but when it's not then it will be executed on each iteration.

>> >> I think a simple memset would be actually ok, i don't think we ever zero
>> >> anything that faults. That would be obviously racy anyways. If the zero
>> >> are supposed to override something  then a racing user thread could always
>> >> catch it.
> >
> > Linus wanted this routine to be extremely dumb. This is the reason why tail
> > handling was moved from assembly to C. Yeah, my original patches were in
> > assembly and on the top of your realization.

My point was that it could be simpler because zeroing should not ever fault
(copy_in_user is not supposed to zero)

-Andi



