Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYAZBNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYAZBNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 20:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYAZBNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 20:13:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYAZBNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:13:39 -0500
Message-ID: <479A883A.50001@zytor.com>
Date: Fri, 25 Jan 2008 17:09:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7A88.6010505@zytor.com> <479A858B.6070102@goop.org>
In-Reply-To: <479A858B.6070102@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
>> Now, all of this reminds me of something somewhat messy: if we share 
>> the kernel page tables for trampoline page tables, as discussed 
>> elsewhere, we HAVE to do a complete, all-tlb-including-global-pages 
>> flush after use, since the kernel pages are global and otherwise will 
>> stick around.  Unlike the permissions pages, there aren't G enable 
>> bits on the higher levels, but only for the PTEs themselves.
> 
> That wouldn't happen to often though, would it.  The identity mapping is 
> only interested in a 1:1 view on RAM, and that's not going to change at 
> all?  Does the TLB cache PAT attributes?  Do you need to do a global 
> flush after changing a PTE's PAT bits to make sure that all that PTE's 
> mappings have a consistent view on memory?
> 

You do need to flush *that page* globally, yes.

As far as flushing after using the trampoline pagetables, we're talking 
about rare, expensive events here like suspend to ram.

	-hpa
