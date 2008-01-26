Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAZF5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAZF5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYAZF5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:57:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:33030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYAZF5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:57:11 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
Date: Sat, 26 Jan 2008 06:57:03 +0100
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7463.7070801@goop.org> <20080126001128.GB24559@elte.hu>
In-Reply-To: <20080126001128.GB24559@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801260657.04398.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008 01:11:28 Ingo Molnar wrote:
(plus 
> any add-on TLB miss costs - but those are amortized quite well as long 
> as the pagetables are well cached - which they usually are on today's 
> 2MB-ish L2 caches), 

Did you measure the cost of that amortizing too?

My guess is that especially with TLBs getting larger and larger the
cost of full CR3 flushes are rising.

> so INVLPG makes sense for pagetable fault realated single-address 
> flushes, but they rarely make sense for range flushes. (and that's how 
> Linux uses it)

I think it would be an interesting experiment to switch flush_tlb_range()
over to INVLPG if the length is below some threshold and see if there 
are visible effects in macro benchmarks. The main problem
would be to determine the right threshold -- would likely be CPU dependent.

-Andi
