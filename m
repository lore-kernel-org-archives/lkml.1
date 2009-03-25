Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZCYXQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZCYXQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZCYXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:15:54 -0400
Received: from gw.goop.org ([64.81.55.164]:56922 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYXPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:15:53 -0400
Message-ID: <49CABB25.8040106@goop.org>
Date: Wed, 25 Mar 2009 16:15:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
References: <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain> <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain>
In-Reply-To: <20090325223642.GK7278@localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Wed, Mar 25, 2009 at 03:16:14PM -0700, Jeremy Fitzhardinge wrote:
>   
>> Ravikiran G Thirumalai wrote:
>>     
>>> It is already there, and has been there!  But we still need to make
>>> vsmp64.c compile only when CONFIG_X86_64 is defined no?
>>>   
>>>       
>> I still think you should restructure it so that vsmp_64.c only gets 
>> compiled with CONFIG_X86_VSMP enabled.  Having all that stuff compiled into 
>> every kernel seems pretty pointless.
>>
>>     
>
> Well, not everything gets compiled in.  Only the is_vsmp_box() logic and
> related stuff gets compiled in.  Other paravirt related stuff in vsmp64.c
> depends on CONFIG_PARAVIRT.
>   

Sure, but it would be cleaner if the whole file were controlled by 
CONFIG_X86_VSMP.  is_vsmp_box() is already defined as const inline 
returning 0 if !CONFIG_X86_VSMP.

    J
> Thanks,
> Kiran
>   

