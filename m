Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYE0QYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYE0QYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYE0QYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:24:43 -0400
Received: from gw.goop.org ([64.81.55.164]:57118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbYE0QYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:24:43 -0400
Message-ID: <483C35AA.5060102@goop.org>
Date: Tue, 27 May 2008 17:24:10 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: Question about interrupt routing and irq allocation
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu> <483BD843.5080009@goop.org> <20080527145606.GB24457@elte.hu>
In-Reply-To: <20080527145606.GB24457@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I'm initially targeting 32-bit, though obviously I'd like something 
>> that works for both 32 and 64 bit.  irq_cfg[] is missing in 
>> io_apic_32.c; would I achieve the same effect by setting 
>> irq_vector[irq] = 0xff or something?
>>     
>
> ok, here comes the next phase of a rather cunning plan: please unify 
> these vector allocators first! ;-)
>   

Somehow I knew you were going to say that...

> it's nontrivial but would result in rather nice code. I dont know 
> whether we want to extend per-CPU vectors to 32-bit as well ... but 
> might be worth an attempt and we could give any exploratory patches a 
> try in -tip. Eric, what do you think about the general approach?
>
> this would also pave the way towards unified APIC code. Hm

All of that sounds very appealing, particularly as the work on xen-dom0 
continues.  But in the meantime I'm just using create_irq(), and I'll 
wear the wasted vector (after all, it will only happen when booting 
under Xen-hvm).

    J
