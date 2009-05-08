Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbZEHPuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbZEHPuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZEHPtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:49:55 -0400
Received: from gw.goop.org ([64.81.55.164]:53170 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZEHPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:49:55 -0400
Message-ID: <4A0454A2.7060104@goop.org>
Date: Fri, 08 May 2009 08:49:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 6/8] x86: use flush_tlb_others to implement	flush_tlb_all
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>	 <1241727902-3176-7-git-send-email-jeremy@goop.org> <1241796269.15972.41.camel@zakaz.uk.xensource.com>
In-Reply-To: <1241796269.15972.41.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Thu, 2009-05-07 at 13:25 -0700, Jeremy Fitzhardinge wrote:
>   
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Use the flush_tlb_others() call to implement flush_tlb_all().
>>     
>
> This causes:
>         BUG: spinlock bad magic on CPU#0, swapper/0
>          lock: c05b7588, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>         Pid: 0, comm: swapper Not tainted 2.6.30-rc3-x86_32p-xen0-tip-01797-g3db7847 #1054
>         Call Trace:
>          [<c023e656>] spin_bug+0x96/0xf0
>          [<c023e90f>] _raw_spin_lock+0x6f/0x150
>   

Ah, right.  I had another change (somewhere around here) to explicitly 
initialize the tlb flush code from the normal early init code, rather 
than make it implicit via initcall.  Otherwise we have an unknown point 
at which we're allowed to start using global flushes, which is a bit flakey.

    J
