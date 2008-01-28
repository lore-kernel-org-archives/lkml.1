Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYA1Uf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYA1Uf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYA1UfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:35:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYA1UfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:35:15 -0500
Message-ID: <479E3B89.20101@zytor.com>
Date: Mon, 28 Jan 2008 12:31:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz> <200801282126.45751.rjw@sisk.pl>
In-Reply-To: <200801282126.45751.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 28 of January 2008, Pavel Machek wrote:
>> Hi!
>>
>>>>>  /*
>>>>>   * Swap suspend & friends need this for resume because things like the intel-agp
>>>>>   * driver might have split up a kernel 4MB mapping.
>>>>>   */
>>>>> -char __nosavedata swsusp_pg_dir[PAGE_SIZE]
>>>>> +char swsusp_pg_dir[PAGE_SIZE]
>>>> thanks, applied.
>> Sorry, this is subtle and I've overlooked it before.
>>
>> (I thought you were only changing ifdef).
>>
>> Now you memcpy() over pg_dir when that pgdir is in use during swsusp
>> resume.
> 
> It is not.  swsusp hasn't been using swsusp_pg_dir for several months.
> Hence, the patch. :-)
> 
>> Granted, you memcpy() with same data that already are there, 
>> but it may still do some funny effects.
>>
>> Hmm, but same argument applies to lower levels of paging in 64-bit and
>> PAE cases, and we still do that memcpy-over-active-pagetables there...
>> :-(.
> 
> Actually, no.  We only do that with the kernel code mapping which should be
> safe as long as TLBs are not flushed (and they aren't).
> 

Okay... does that in any way affect using the kernel code mapping 
synchronization code to maintain a set of trampoline pagetables?

	-hpa
