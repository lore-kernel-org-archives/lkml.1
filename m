Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYH1VAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYH1VAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYH1VAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:00:01 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:22741 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYH1VAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XNxPvKb6ifzB1ZhQlwCnZF+DIiw06UU/cBBcvvb4f5dhjQDAAVdu93oW7mDR8b4GRD
         tKQg/NvtvSwTJOtTavA29oruaMFS1o/vQ39NcM6GKJK9H64F2edLI/d9hV7haExBNitz
         jLeunaG2AFrBQnllwTBbVfFGzFpk2mo49Bvp4=
Message-ID: <19f34abd0808281359p6ee01393x209f2bf2de3918af@mail.gmail.com>
Date: Thu, 28 Aug 2008 22:59:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [RFC][PATCH] bitfields API
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080828202750.GB16462@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828183223.GA30781@localhost.localdomain>
	 <20080828184025.GA22165@x200.localdomain>
	 <48B6F12F.1010909@cs.helsinki.fi>
	 <20080828202750.GB16462@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 10:27 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Aug 28, 2008 at 09:40:47PM +0300, Pekka Enberg wrote:
>> Hi Alexey,
>>
>> Alexey Dobriyan wrote:
>>> On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
>>>> How do you feel about this patch? It's all about making kmemcheck more
>>>> useful... and not much else. Does it have any chance of entering the
>>>> kernel along with kmemcheck (when/if that happens)?
>>>
>>> DEFINE_BITFIELD is horrible.
>>
>> Heh, heh, one alternative is to have a kmemcheck_memset() thingy that
>> unconditionally zeroes bit fields and maybe is a no-op when kmemcheck is
>> disabled.
>
> This sounds as if this might cause bugs to disappear when debugging gets
> turned on?
>
> Or do I miss anything?

You are correct :-)

Almost all the possible solutions (at least the feasible ones) are
trade-offs between false-positives and false-negatives.

So here we are trading a bunch of false-positive errors (a couple of
thousand for transferring a 1M file over ssh :-)) for detecting any
code that uses an uninitialized flag in struct skbuff. So in this case
it is more useful to hide reports about this single bit-field.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
