Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946Ab0AUQet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0AUQet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0AUQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:34:48 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58353 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0AUQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=irpzJlEojTEqHxpfd3xltWg3SAtpEf1siSN1b/dK7VcUQrlA0CufVXDOdrq70f5B1s
         YZvIwN9hp30L/Ktmu41axD54m6zn++nx10tRLBGboWHCRsKV3ROCpZqQUvOzXbNRtffY
         WICVG7vyBe7eSP2GEAIwOK1FAyedNSAp0GsTY=
From: Don Mullis <don.mullis@gmail.com>
To: dedekind@infradead.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, andi@firstfloor.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
References: <87fx609i29.fsf@gmail.com> <1264065775.3032.18.camel@localhost>
	<20100121095434.GA25842@discord.disaster>
	<1264074259.3032.25.camel@localhost>
Date: Thu, 21 Jan 2010 08:34:40 -0800
In-Reply-To: <1264074259.3032.25.camel@localhost> (Artem Bityutskiy's message
	of "Thu, 21 Jan 2010 13:44:19 +0200")
Message-ID: <87zl478li7.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind@infradead.org> writes:

> On Thu, 2010-01-21 at 20:54 +1100, Dave Chinner wrote:
>> On Thu, Jan 21, 2010 at 11:22:55AM +0200, Artem Bityutskiy wrote:
>> > 
>> > Could you please add a debugging function which would be compiled-out
>> > normally, and which would check that on the output 'list_sort()' gives
>> > really sorted list, and number of elements in the list stays the same.
>> > You'd call this function before returning from list_sort(). Something
>> > like:
>> > 
>> > #ifdef DEBUG_LIST_SORT
>> > static int list_check(void *priv, struct list_head *head,
>> >                       int (*cmp)(void *priv, struct list_head *a,
>> >                                  struct list_head *b))
>> > {
>> >    /* Checking */
>> > }
>> > #else
>> > #define list_check(priv, head, cmp) 0
>> > #endif
>> > 
>> > This will provide more confidence in the algorithm correctness for
>> > everyone who modifies 'list_sort()'.
>> 
>> I'd suggest the same method as employed in lib/sort.c - a
>> simple userspace program that verifies correct operation is included
>> in lib/sort.c....
>
> Yeah, that's also an option.

Okay. The regression test in lib/sort.c is kernel-space, run once at
boot. I'd like to do something similar for lib/list_sort.c, conditioned
on DEBUG_LIST_SORT. I would extend the testing to verify stability as
well as sort order and number of elements.
