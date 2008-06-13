Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbYFMHY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbYFMHY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbYFMHYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:24:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47178 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbYFMHYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:24:39 -0400
Date: Fri, 13 Jun 2008 09:24:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
Message-ID: <20080613072424.GB11976@elte.hu>
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com> <484901A3.3040401@goop.org> <20080610103151.GG19136@elte.hu> <484E7C5D.50701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E7C5D.50701@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>>> When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can  
>>> potentially have the same number of physical address bits as the  
>>> 64-bit host ("Enhanced Legacy PAE Paging").  This means, in theory, 
>>> we could have up to 52 bits of physical address in a pte.
>>>
>>> The 32-bit kernel uses a 32-bit unsigned long to represent a pfn. 
>>> This means that it can only represent physical addresses up to 
>>> 32+12=44 bits wide.  Rather than widening pfns everywhere, just set 
>>> 2^44 as the Linux x86_32-PAE architectural limit for physical address 
>>> size.
>>>     
>>
>> applied to tip/x86/cleanups - thanks Jeremy. No urgency for v2.6.26, 
>> right?
>
> Not urgent, but it would be nice to have.

ok, cherry-picked it into x86/urgent. This aspect makes it eligible for 
v2.6.26:

| This is a bugfix for two cases:
| 1. running a 32-bit PAE kernel on a machine with
|   more than 64GB RAM.
| 2. running a 32-bit PAE Xen guest on a host machine with
|   more than 64GB RAM
|
| In both cases, a pte could need to have more than 36 bits of physical,
| and masking it to 36-bits will cause fairly severe havoc.

also added a stable@kernel.org Cc: to the commit, so it will be picked 
up in stable as well.

	Ingo
