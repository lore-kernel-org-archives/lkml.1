Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZE3J3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZE3J3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZE3J3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:29:22 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:40996 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZE3J3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:29:21 -0400
Date: Sat, 30 May 2009 02:27:03 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530092703.GP29711@oblivion.subreption.com>
References: <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530093147.02d5ed76@lxorguk.ukuu.org.uk> <4A20EFB7.5050808@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A20EFB7.5050808@cs.helsinki.fi>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:35 Sat 30 May     , Pekka Enberg wrote:
> Alan Cox wrote:
>> The problem is that most sensitive data is user space anyway.
>> GFP_SENSITIVE or kzfree mean you have to get it right in the kernel and
>> you don't fix things like stack copies of sensitive data - its a quick
>> hack which doesn't meet goot security programming practice -it defaults
>> to insecure which is the wrong way around. Not saying its not a bad idea
>> to kzfree a few keys and things *but* it's not real security.
>> If you want to do real security you have a sysfs or build flag that turns
>> on clearing every page on free. Yes it costs performance (a lot less
>> nowdays with cache bypassing stores) but for the category of user who
>> wants to be sure nothing escapes it does the job while kzfree would be
>> like trying to plug leaks in a sieve.
>
> Yup, your suggestion would make one simple patch, for sure.

This was the first approach taken after Alan and others objected to the
use of a page flag. A patch using a build time config option was
submitted, which is the same way PaX's feature works currently, and Alan
asked for a runtime option instead.

> I wonder if  anyone is actually prepared to enable the thing at run-time, though, which 
> is why I suggested doing the "critical" kzfree() ones unconditionally.

I don't know how many times I need to repeat that if you think the point
here is doing selective sanitization, or that it does any good, you are
totally missing it. Please take some time off and read the past remarks
I made in this thread, especially the analysis of almost a dozen kernel
vulnerabilities which could have been prevented or minimized in terms of
damage (besides coldboot/iceman attacks and so forth, refer to the
Princeton and Stanford papers):

http://marc.info/?l=linux-mm&m=124301548814293&w=2

The very first patchset did change the crypto api, af_key and other
sources to use clearing on release time. Also, regarding your
hesitations about who is prepared to enable full unconditional
sanitization of memory... maybe not you, because you likely don't care
or require this _for yourself_.

Don't assume your perceived level of security risks matches that of the
rest of the real world. This is clearly not something your average
university sysadmin might use. Like Alan put it out nicely, if you need
this, you know why and are well aware of the ups and downs.

Fallacies like this are the basis of every security failure so far.

	Larry
