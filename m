Return-Path: <linux-kernel-owner+w=401wt.eu-S2992432AbXCGSON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992432AbXCGSON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992431AbXCGSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:14:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42552 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992432AbXCGSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:14:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai.lu@amd.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64 irq: keep consistent for changing IRQ0_VECTOR from 0x20 to 0x30
References: <86802c440703052359q3242f771ne9c10752613820d3@mail.gmail.com>
	<Pine.LNX.4.64.0703061942000.5963@woody.linux-foundation.org>
Date: Wed, 07 Mar 2007 11:13:34 -0700
In-Reply-To: <Pine.LNX.4.64.0703061942000.5963@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 6 Mar 2007 19:43:50 -0800 (PST)")
Message-ID: <m1irdcdir5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 5 Mar 2007, Yinghai Lu wrote:
>>
>> please check the patch
>
> Hmm.. It doesn't look *wrong*, but could you please
>
>  - split it up a bit (some of it is 100% obvious, ie the comment fixes)
>
>  - write an explanation for the individually split up patches
>
>  - not use attachments, but just make it inline. It's practically 
>    impossible to reply and quote part of the patch now.
>
> Eric/Ingo - did you go through and check the patch?

This patch will probably work but I'm against it, as is.

The comment fixes or some variation on them are needed.

But code that assumes we place IRQ0 at a particular place isn't
exactly bad but it is brittle.  If we are to reduce our array size
we can also shave a lot of entries off the top because we mostly use
the high end of the vector range for IPI's.

So if we were to introduce some set of defines of exactly which
vectors we can use and do a thorough job of this I think there may
be something reasonable we can do here.

Unless this makes the code clearer I don't think there is much point
in reducing a fixed sized array from 224 entries to 191 entries, and
it has the potential to make this much less pleasant if we goof up
elsewhere.

Eric
