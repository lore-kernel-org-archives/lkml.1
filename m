Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbYBLBB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbYBLBB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYBLBBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:01:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYBLBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:01:46 -0500
Message-ID: <47B0EE46.6050208@zytor.com>
Date: Mon, 11 Feb 2008 16:54:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Michael Opdenacker <michael-lists@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for	some	processors
References: <200802082347.25364.michael-lists@free-electrons.com>	 <20080208231130.GA10511@elte.hu>	 <200802112342.23493.michael-lists@free-electrons.com>	 <1202770566.12383.59.camel@cinder.waste.org>  <47B0D3B7.6070308@zytor.com> <1202772532.12383.67.camel@cinder.waste.org>
In-Reply-To: <1202772532.12383.67.camel@cinder.waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2008-02-11 at 15:01 -0800, H. Peter Anvin wrote:
>> Matt Mackall wrote:
>>> Best would be to have no ifdefs and do it all with linker magic, of
>>> course. But that's trickier.
>>>
>> I concur with this, definitely.
> 
> Ok, so let's come up with a plan. We can:
> 
> a) use weak symbols, ala cond_syscall
> b) use a special section
> c) use early_init code (is it early enough?)
> c) have some sort of registration list
> 
> Having a generic cond_call of some sort might be nice for this sort of
> thing.
> 

c) is out, because this has to be executed after the early generic code 
and before the late generic code.

b) would be my first choice, and yes, it would be a good thing to have a 
generalized mechanism for this.  For the registrant, it's pretty easy: 
just add a macro that adds a pointer to a named section.  We then need a 
way to get the base address and length of each such section in order to 
be able to execute each function in sequence.

	-hpa

