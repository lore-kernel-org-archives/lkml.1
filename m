Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYBDQjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYBDQjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYBDQjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:39:00 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:43486 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYBDQi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:38:59 -0500
Message-ID: <47A73F97.1040804@freescale.com>
Date: Mon, 04 Feb 2008 10:38:47 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: add __asm__ to function-space-paren exception
 list
References: <12016486482483-git-send-email-timur@freescale.com> <20080204112203.GA19879@shadowen.org>
In-Reply-To: <20080204112203.GA19879@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:

> It truly is not clear what "type" of thing an __asm__ is these days.
> Cirtainly it seems we can use it as an attribute of a type:
> 
>         register unsigned long __r16 __asm__("$16") = rtc_access->function;
> 
> and yet also in its more traditional form:
> 
> 	__asm__("	call foo");
> 
> The latter form feels like a function? 

But it's not.  Sure, it defines a block of code that has input and output 
parameters, but one key distinction is that __asm__ is not the name of the 
"function".

? But cirtainly in the examples it
> is shown with a space some of the time, and not others. 

Well, since checkpatch.pl insists that the space be removed, that's probably why 
it's not there a lot of the time.

> Is __asm__ an
> attribute of the null function (;) in this context or ... well ?

I don't think __asm__ can be compared to other C-language syntax constructs.

> This patch really just removes any checks for spacing on __asm__ do we
> have a preferred style for these? 

I don't know, but I do know it's wrong for checkpatch.pl to think that "__asm__" 
is the name of a function.

 > Attributes do seem to have spaces,
> though in their most attribute like usage the __asm__ "attribute" does
> not seem to be used with a space, so far anyhow.

The problem is that checkpatch.pl thinks this is okay:

	__asm__ __volatile__ ("call foo");

but it doesn't like this:

	__asm__ ("call foo");

> Oh and why are we preferring the use of __asm__ over asm?  They both
> seem valid.  Should we be recommending one over the other?

It's a toss-up.  Depending on the architecture, one version has about 60% usage 
and the other about 40%.  I thought I read somewhere that __asm__ is preferred, 
but I can't remember where I read that or who wrote it.

-- 
Timur Tabi
Linux kernel developer at Freescale
