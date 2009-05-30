Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZE3Ije@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZE3Ije (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZE3Ij1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:39:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53559 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZE3Ij0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:39:26 -0400
Message-ID: <4A20EFB7.5050808@cs.helsinki.fi>
Date: Sat, 30 May 2009 11:35:03 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
 allocator
References: <20090520183045.GB10547@oblivion.subreption.com>	<4A15A8C7.2030505@redhat.com>	<20090522073436.GA3612@elte.hu>	<20090522113809.GB13971@oblivion.subreption.com>	<20090523124944.GA23042@elte.hu>	<4A187BDE.5070601@redhat.com>	<20090527223421.GA9503@elte.hu>	<20090528072702.796622b6@lxorguk.ukuu.org.uk>	<20090528090836.GB6715@elte.hu>	<20090528125042.28c2676f@lxorguk.ukuu.org.uk>	<84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530093147.02d5ed76@lxorguk.ukuu.org.uk>
In-Reply-To: <20090530093147.02d5ed76@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> The problem is that most sensitive data is user space anyway.
> GFP_SENSITIVE or kzfree mean you have to get it right in the kernel and
> you don't fix things like stack copies of sensitive data - its a quick
> hack which doesn't meet goot security programming practice -it defaults
> to insecure which is the wrong way around. Not saying its not a bad idea
> to kzfree a few keys and things *but* it's not real security.
> 
> If you want to do real security you have a sysfs or build flag that turns
> on clearing every page on free. Yes it costs performance (a lot less
> nowdays with cache bypassing stores) but for the category of user who
> wants to be sure nothing escapes it does the job while kzfree would be
> like trying to plug leaks in a sieve.

Yup, your suggestion would make one simple patch, for sure. I wonder if 
anyone is actually prepared to enable the thing at run-time, though, 
which is why I suggested doing the "critical" kzfree() ones unconditionally.

			Pekka
