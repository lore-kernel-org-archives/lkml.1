Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab0BRPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:24:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34075 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab0BRPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:24:46 -0500
Message-ID: <4B7D5AC6.9070103@zytor.com>
Date: Thu, 18 Feb 2010 07:20:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Luca Barbieri <luca@luca-barbieri.com>, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] x86-32: support atomic64_t on 386/486 UP/SMP
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-9-git-send-email-luca@luca-barbieri.com> <1266488746.26719.120.camel@laptop>
In-Reply-To: <1266488746.26719.120.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 02:25 AM, Peter Zijlstra wrote:
> On Wed, 2010-02-17 at 12:42 +0100, Luca Barbieri wrote:
>> This patch makes atomic64 use either the generic implementation or
>> the rewritten cmpxchg8b one just introduced by inserting a "call" to
>> either, using the alternatives system to dynamically switch the calls.
>>
>> This allows to use atomic64_t on 386/486 which lack cmpxchg8b
> 
> IIRC we dropped <i586 SMP support, and since we don't have a PMU on
> those chips atomic64_t doesn't need to be NMI safe, so a simple
> UP-IRQ-disable implementation should suffice.

... which is what we have now, with the cmpxchg8b alternates emulation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

