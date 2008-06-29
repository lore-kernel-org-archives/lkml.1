Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYF2Le5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYF2Le5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYF2Ler
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 07:34:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:32594 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYF2Leq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 07:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f2uSFTBMdCaImDR6oqLjiAAySWEsxHifC+P2TZMheWWd8GM7/j1hvx3m+pOWGl+yMh
         5fctCxltZGXbTVLxb+ZNzu0CAkZd4BJyScMecP2nS4Qp7MBef0/uNXxb9g0ZqHu46cwb
         eMHsZ74gYUxZ1linA8ZUCGA8+XBuBok48JbV4=
Message-ID: <19f34abd0806290434l836e858p47850eb96addd0b3@mail.gmail.com>
Date: Sun, 29 Jun 2008 13:34:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48652B6A.7060007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>
	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>
	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>
	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>
	 <19f34abd0806271024j53b383ddq33ab2b58debfbb65@mail.gmail.com>
	 <48652B6A.7060007@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 8:03 PM, Mike Travis <travis@sgi.com> wrote:
>> So if CONFIG_DEBUG_RODATA=y, I believe we'll see first this warning,
>> then a panic (after all). Would it be better to make cpu_mask_none
>> non-const, in spirit of trying to continue as far as possible? I don't
>> really know if it matters, though. It seems that fedora kernels at
>> least ship with a default of DEBUG_RODATA=y.
>>

...

> Ingo asked me to add the "const".  But it would be a mistake to use
> node_to_cpumask_ptr to modify the map... numa_set/clear_node is the
> proper way to modify the maps.  Hmm, maybe I should add "const" to
> the real node_to_cpumask_ptr function, at least then the compiler
> would help spot illegal usages.

That sounds like a brilliant idea, as long as none of the callers
expect it to be non-const.

I changed it to return const to see, and built allmodconfig + a few
randconfigs without error (well, warning). There are not that many
users of this function anyway.

BTW, what's up with the topology.h/setup_percpu.c mismatch, when
topology.c exists as well?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
