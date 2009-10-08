Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZJHU3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZJHU3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbZJHU3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:29:08 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63269 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZJHU3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=wjXQJI30YT4ea4bUIdWwh6I9zgRSkTtUV1dtTm1VUpAVJUco4n9jUS8vx0c8MIwVWP
         8B7FxT9Wv/PgybNQMEl1Gbr42xibsXzHLABwvbeQ4kb8lwbyeXELdzalzg5z/Va4HM9t
         n+Y9sIiASz9U8HRz8YrycCOHKJpjru0AhrwR4=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20091008200839.GA24354@elte.hu>
References: <1254911461.26976.239.camel@twins>
	 <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
	 <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
	 <20091007.134626.238756485.davem@davemloft.net>
	 <20091008200839.GA24354@elte.hu>
Date: Thu, 8 Oct 2009 22:28:29 +0200
Message-ID: <7c86c4470910081328r24be0f63ha436b008b66077c4@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 10:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * David Miller <davem@davemloft.net> wrote:
>
>> From: stephane eranian <eranian@googlemail.com>
>> Date: Wed, 7 Oct 2009 14:31:58 +0200
>>
>> > What PPC does is probably the only way to do this given the interface between
>> > generic and machine-specific code. The one advantage I see is that it works
>> > inside an event group but also across event groups because that code does not
>> > look at group boundary, it only looks at the events and the number of available
>> > registers. The downside is that you duplicate state.
>> >
>> > Did I get this right, Paul?
>>
>> That's basically how his code works, yes.  I intend on duplicating it
>> to some extent on sparc64 since I'm operating in a similar problem
>> space.
>>
>> So if at least some of this engine went to a generic place, there'd be
>> at least a 3rd user :-)
>
> Yeah, i'd definitely suggest to generalize this. We've missed updating
> PowerPC lowlevel details a couple of times in perf core updates, just
> because it's in a non-obvious place. Even if it's used by just a single
> arch, generic code is much more visible.
>

It is not clear how you can do this without creating a monster.
As I said the constraints can be far more difficult than just
event X => allowed_counter_bitmask.
