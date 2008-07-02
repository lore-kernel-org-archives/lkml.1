Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYGBPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYGBPch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYGBPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:32:26 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:57742 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYGBPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=jsgtPRw2+i97mnFuH2hUs1rN9+kwES9DywmaMxNBgvaHh1PMQbvsr3GZCO52hP4q0Z
         r03X52PgSgx/ERP8kqFKHotkfK4NUlgS3OQcgI2wL1e8/2JUmrj+o6lMlXJ9PziRsYhc
         3yBXtc70/w6rqfwTLeUlTzsRlibF7tbX4httY=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
	<486B9987.8000601@firstfloor.org>
Date: Wed, 02 Jul 2008 17:32:20 +0200
In-Reply-To: <486B9987.8000601@firstfloor.org> (Andi Kleen's message of "Wed,
	02 Jul 2008 17:06:47 +0200")
Message-ID: <m3y74ki9ob.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>>> >> Overall you could write it much simpler with a rep ; movs I think,
>>> >> like traditional linux did.
>> >
>> > rep movs can fail.
>
> How? (if it's a byte copy?)

Parameter len is a number of uncopied bytes, it doesn't count bytes
which were loaded into registers before GPF in unrolled
loop. copy_user_handle_tail tries to do a byte copy for, possibly,
remaining bytes, but it can fail at the first read/write, or at the
second, etc. It doesn't know where it will fail.

> The old 2.4 copy_*_user always used to that and it worked just fine AFAIK.

Again, Linus wanted it to be simple plain C routine. rep movs is not in
C language ;)

>>> >> If zerorest is ever 0 then retesting it on every iteration seems
>>> >> somewhat dumb.
>> >
>> > If zerorest is 0, this cycle will never be executed.
>
> Ok but when it's not then it will be executed on each iteration.

Ok, that's matter.

>>> >> I think a simple memset would be actually ok, i don't think we ever zero
>>> >> anything that faults. That would be obviously racy anyways. If the zero
>>> >> are supposed to override something  then a racing user thread could always
>>> >> catch it.
>> >
>> > Linus wanted this routine to be extremely dumb. This is the reason why tail
>> > handling was moved from assembly to C. Yeah, my original patches were in
>> > assembly and on the top of your realization.
>
> My point was that it could be simpler because zeroing should not ever fault
> (copy_in_user is not supposed to zero)

Why do you think that zeroing can never fail, even in userspace?
-- 
wbr, Vitaly
