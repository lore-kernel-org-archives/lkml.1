Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYKSAId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYKSAId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYKSAIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:08:17 -0500
Received: from gw.goop.org ([64.81.55.164]:49450 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYKSAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:08:16 -0500
Message-ID: <492358ED.5090904@goop.org>
Date: Tue, 18 Nov 2008 16:08:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       heukelum@fastmail.fm, Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC,v2] x86_64: save_args out of line
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain> <20081118233552.GP6703@one.firstfloor.org> <49235178.2050108@goop.org> <49235347.7010005@zytor.com>
In-Reply-To: <49235347.7010005@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Not really.  At the moment we have two parallel assembly languages 
>> which say different things about the same instructions.  In practice, 
>> almost nobody understands the cfi parts, so they just get ignored 
>> while the x86 instructions change around them, leaving them either 
>> stale or missing.
>>
>> If we had a sensible macro layer which emits both instructions and 
>> cfi annotations, it at least means that people who write plain x86 
>> instructions will simply get no annotations, and people who bother to 
>> learn the (clearly and fully documented) macros will get the best of 
>> both.
>>
>
> I think that it would be nice to have macros for the most commonly 
> annotatable instructions, e.g. push, and stack pointer movement.  Just 
> compactifying the code should improve readability, if perhaps not 
> writability.

Yes.  Something that obviously relates to both the instruction and the 
semantic intent of the annotation: add_sp, sub_sp, save_reg, etc.  And 
at least that will eliminate the differently-signed(!) constant for 
stack movement.

    J
>
>     -hpa

