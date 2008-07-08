Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYGHRgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYGHRgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYGHRf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:35:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:55817 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbYGHRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hy+tCfcTcUxZYAHrwdBcxHT3Z9k9tf2dsIgCQ7bnfurcAt0chbkFa37byd5N2BKf/3
         PkSo28W8qFwkRDR4T2juHMPuhmDiNLZZR3SqDtliBn/l0haBoHyCpub1R+ynMNym582Y
         ZfuB8ddTEm6vNcZBn5UJHFCiUhlVfYg32sEDQ=
Message-ID: <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>
Date: Tue, 8 Jul 2008 19:35:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48739E87.2060604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <484D54F2.4070603@sgi.com> <20080626113229.GB29619@elte.hu>
	 <4863C334.2090007@sgi.com> <486452CC.8050502@sgi.com>
	 <48651EF5.5090808@sgi.com> <20080703084401.GB7873@elte.hu>
	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>
	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 8, 2008 at 7:06 PM, Mike Travis <travis@sgi.com> wrote:
>> (v3 is applied already so Mike please send a delta to v3.)
>>
>>       Ingo
>
> Subject: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
>
>  * Strengthen the return type for the _node_to_cpumask_ptr to be
>    a const pointer.  This adds compiler checking to insure that
>    node_to_cpumask_map[] is not changed inadvertently.
>
> Applies to tip/master with the following patch applied:
>
>        "[PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3"
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> Note: I did not change node_to_cpumask_ptr() in include/asm-generic/topology.h
>      as node_to_cpumask_ptr_next() does change the cpumask value.

Hmmm. Does it really?

#define node_to_cpumask_ptr_next(v, node)                               \
                          _##v = node_to_cpumask(node)

This doesn't seem to modify it?

Also, isn't it unfortunate to have the same function return
const/non-const depending on your arch/config?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
