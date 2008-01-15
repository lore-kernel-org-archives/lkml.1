Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYAOWgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYAOWgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYAOWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:35:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45193 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYAOWfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:35:52 -0500
Date: Tue, 15 Jan 2008 23:35:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080115223534.GA20484@elte.hu>
References: <patchbomb.1200435425@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1200435425@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> Hi Ingo,
> 
> More patches:
> 
> - rearrange paravirt.h to remove duplicate code, and to make it easy
>   to drop in 4th level pagetable functions.
> - fix a warning I got from clear_bit in pgtable.h
> - fix up some bogosity in pte_modify
> - mask NX from pte_pfn
> 
> The last two may help with the problem that Andi's seeing.

unfortunately they dont solve it:

 [   92.042586] Freeing unused kernel memory: 328k freed
 [   92.091838] khelper used greatest stack depth: 6244 bytes left
 [   92.281738] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
 [   92.288761] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
 [   92.295763] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
 [...]
 [   97.312484] printk: 611046 messages suppressed.

32-bit, PAE and RAM above 4GB seems to be enough to trigger that bug.

	Ingo
