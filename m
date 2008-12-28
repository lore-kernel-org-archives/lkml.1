Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYL1U2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYL1U2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 15:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYL1U2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 15:28:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYL1U2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 15:28:44 -0500
Message-ID: <4957E17A.9080203@redhat.com>
Date: Sun, 28 Dec 2008 22:28:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
References: <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com> <20081228190840.GD496@one.firstfloor.org> <4957CE78.6030706@redhat.com> <4957D14B.60805@redhat.com> <4957DCC3.3060505@redhat.com> <20081228203425.GF496@one.firstfloor.org>
In-Reply-To: <20081228203425.GF496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This makes the whole thing unworthwhile.  The vmload/vmsave pair costs 
>> only 200 cycles (I should have started with this), and 120 cycles on the 
>> heavyweight path plus complexity are not worth 200 cycles on the 
>> lightweight path.
>>     
>
> Actually to switch ISTs you need to change the TSS, not the IDT.
> But I suppose that won't be any faster.
>   

I can't touch the TSS (that's the starting point of the exercise).  The 
plan was to have a copy of the IDT with all IST pointers zeroed out (or 
to have per-cpu IDT and zero out the IST pointers when entering guest 
mode, restoring them on context switch).

It's not worth it though.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

