Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbZDIE7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbZDIE7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZDIE7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:59:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43238 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZDIE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:59:42 -0400
Message-ID: <49DD80B4.5060301@jp.fujitsu.com>
Date: Thu, 09 Apr 2009 13:59:32 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org>	<20090407150656.43E161D046D@basil.firstfloor.org>	<49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org>
In-Reply-To: <87eiw3a29h.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:
> 
>> Andi Kleen wrote:
>>> From: Huang Ying <ying.huang@intel.com>
>>>
>>> Return rip/cs if MCG_STATUS_EIPV is set in mce_get_rip(). Remain m->cs
>>> if RIP is read from rip_msr.
>> It means we use "Error IP" as "Return IP" if RIPV=0 but EIPV=1 ...?
>> Sounds strange.
> 
> It's not return IP, but "reported IP" in this case.

Wait, I'm ashamed to say, it seems we missed the name of instruction
pointer register: The 64bit one is RIP, and the 32bit one is EIP.

Anyway we have proved a major point - It is confusing expression.

>> I guess it would make much sense if we stop mixing RIP and EIP and rename
>> the mce_get_rip() to mce_get_eip(), and the rip_msr to eip_msr too.
> 
> Ok fair enough.  I admit the code was always a bit dubious.
> 
>> And then it would be acceptable if we print RIP with "!INEXACT!" annotation
>> instead of printing precise EIP in case of RIPV=0 but EIPV=1.
> 
> Please send a patch to do all that.

I will.

A trivial question is if you unified 32/64bit mce codes, would you
like to print only "IP %02x:<%016Lx>", or "RIP ..." and "EIP ..." ?


Thanks,
H.Seto

