Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYAZAYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYAZAYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYAZAYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:24:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYAZAYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:24:39 -0500
Message-ID: <479A7CCB.7070501@zytor.com>
Date: Fri, 25 Jan 2008 16:20:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7463.7070801@goop.org> <20080126001128.GB24559@elte.hu>
In-Reply-To: <20080126001128.GB24559@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> Is there any guide about the tradeoff of when to use invlpg vs 
>> flushing the whole tlb?  1 page?  10?  90% of the tlb?
> 
> i made measurements some time ago and INVLPG was quite uniformly slow on 
> all important CPU types - on the order of 100+ cycles. It's probably 
> microcode. With a cr3 flush being on the order of 200-300 cycles (plus 
> any add-on TLB miss costs - but those are amortized quite well as long 
> as the pagetables are well cached - which they usually are on today's 
> 2MB-ish L2 caches), the high cost of INVLPG rarely makes it worthwile 
> for anything more than a few pages.
> 
> so INVLPG makes sense for pagetable fault realated single-address 
> flushes, but they rarely make sense for range flushes. (and that's how 
> Linux uses it)
> 

Incidentally, as far as I can tell, the main INVLPG is so slow is 
because of its painful behaviour with regards to large pages which may 
have been split by hardware.

	-hpa
