Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbZJLR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbZJLR5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbZJLR5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:57:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35297 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889AbZJLR5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:57:22 -0400
Date: Mon, 12 Oct 2009 19:56:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       arjan@infradead.org, hmh@hmh.eng.br, rdreier@cisco.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/pat] x86: Relegate CONFIG_PAT and CONFIG_MTRR
	configurability to EMBEDDED
Message-ID: <20091012175626.GA17138@elte.hu>
References: <20091011103302.62bded41@infradead.org> <tip-c03cb3149daed3e411657e3212d05ae27cf1a874@git.kernel.org> <4AD36723.5040502@zytor.com> <4AD36B42.9060608@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD36B42.9060608@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> H. Peter Anvin wrote:
>> On 10/12/2009 04:10 AM, tip-bot for Arjan van de Ven wrote:
>>> Commit-ID:  c03cb3149daed3e411657e3212d05ae27cf1a874
>>> Gitweb:     http://git.kernel.org/tip/c03cb3149daed3e411657e3212d05ae27cf1a874
>>> Author:     Arjan van de Ven <arjan@infradead.org>
>>> AuthorDate: Sun, 11 Oct 2009 10:33:02 -0700
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Mon, 12 Oct 2009 13:06:57 +0200
>>>
>>> x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability to EMBEDDED
>>>
>>> MTRR and PAT support (which got added to CPUs over 10 years ago)
>>> are no longer really optional in that more and more things are
>>> depending on PAT just working, including various drivers and newer
>>> versions of X.  (to not even speak of MTRR)
>>>
>>> Having this as a regular config option just no longer makes sense.
>>>
>>> This patch relegates CONFIG_X86_PAT to the EMBEDDED category so
>>> ultra-embedded can still disable it if they really need to.
>>>
>>
>> Should we combine this with removing the whitelist (which is largely 
>> vestigial at this point) and replace it with a blacklist (possibly 
>> empty)?  I still haven't seen any evidence that there are any CPUs 
>> which have problems, and PAT support go back all the way to Pentium 
>> III -- and page table attributes can be used all the way back to 386, 
>> it just excludes the WC type.
>
> I would be in favor of that; other operating systems have been using 
> pat everywhere since the pII days anyway.

Fine to me too. We only made it a whitelist to reduce the degrees of 
freedom early in the implementation - it stuck around needlessly long.

	Ingo
