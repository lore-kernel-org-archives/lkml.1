Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYFJNGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYFJNGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYFJNF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:05:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYFJNF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:05:57 -0400
Message-ID: <484E7B03.8000604@redhat.com>
Date: Tue, 10 Jun 2008 10:00:51 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>	 <1213021018-14159-10-git-send-email-gcosta@redhat.com>	 <1213021018-14159-11-git-send-email-gcosta@redhat.com>	 <1213021018-14159-12-git-send-email-gcosta@redhat.com>	 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>	 <484D8813.4040807@redhat.com>	 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>	 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>	 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl>	 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl> <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
In-Reply-To: <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Jun 9, 2008 at 7:46 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>> On Mon, 9 Jun 2008, Maciej W. Rozycki wrote:
>>
>>>> we need clear_IO_APIC before enable setup error vector, in case there
>>>> is wrong setting in ioapic by BIOS...
>>>  Fair enough, although it is still interesting why it would only trigger
>>> in the 64-bit mode and why shouldn't the BIOS be fixed instead.
>>  Then again -- what if X86_LOCAL_APIC is set, but X86_IO_APIC is not?
> 
> config X86_LOCAL_APIC
>         def_bool y
>         depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS ||
> SMP) && !X86_VOYAGER) || X86_GENERICARCH))
> 
> config X86_IO_APIC
>         def_bool y
>         depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP &&
> !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
> 
> for 64bit, those are all set.
> 
> for 32bit, may need to null stub if X86_IO_APIC is not set
> 
> YH
Fair Enough.
