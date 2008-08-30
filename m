Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYH3BPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYH3BPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 21:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYH3BPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 21:15:34 -0400
Received: from gw.goop.org ([64.81.55.164]:41371 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYH3BPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 21:15:33 -0400
Message-ID: <48B89F33.30507@goop.org>
Date: Fri, 29 Aug 2008 18:15:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Rafa=3F_Mi=3Fecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory	corruption
References: <48B701FB.2020905@goop.org>	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>	 <48B76CE0.5010309@goop.org> <1220041877.9776.26.camel@localhost>
In-Reply-To: <1220041877.9776.26.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Thu, 2008-08-28 at 20:28 -0700, Jeremy Fitzhardinge wrote:
>   
>> Yinghai Lu wrote:
>>     
>>> On Thu, Aug 28, 2008 at 12:52 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>       
> <snip>
>   
>> Yeah, OK, but I think it should default to ON for now.  The problem is
>> that we had two very different systems (Sony Vaio and Intel desktop)
>> exhibit the same problem in two different ways.  These systems worked
>>     
>
> This is very interresting. I have a gigabyte X48 board, and everything
> works perfect, however, in memtest86+ i get thousands of errors in the
> range 0-0.9mb. I am certain my ram is fine, i've tried it in other
> computers, and reversed. I've run dozens of stress tests within my
> booted linux, no trouble, also the userspace memtester (allthough im
> aware it wont actually ever get to grab offending addresses).
>
> Any thoughts?
>   

I would expect you'd get crashes if you had massive corruption in that
area.  By default it's being used for the kernel pagetables, so stomping
on them will cause problems.  In the cases we've been looking at so far,
it's only been a word or two being stomped.

The low 1Mbyte is used as general memory, so corruption over the whole
area will have widespread effects.

But try this patch (Hugh's version) and see what happens.

    J
