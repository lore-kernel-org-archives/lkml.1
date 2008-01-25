Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYAYXoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYAYXoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYAYXoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:44:39 -0500
Received: from gw.goop.org ([64.81.55.164]:38355 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYAYXoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:44:38 -0500
Message-ID: <479A7463.7070801@goop.org>
Date: Fri, 25 Jan 2008 15:44:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> Go read the Intel application note "TLBs, Paging-Structure Caches, and Their
> Invalidation" at http://www.intel.com/design/processor/applnots/317080.pdf
>
> Section 8.1 explains about the PDPTR cache in 32-bit PAE mode, which can
> only be refreshed by appropriate tickling of CR0, CR3 or CR4.
>   

Yeah, I found that document, and mentioned it a little lower in the mail ;)

> It is also important to note that *any* valid page directory entry at *any*
> level in the page-table hierarchy can become cached at *any* time. Basically
> TLB lookup is performed as a longest-prefix match on the linear address to
> skip as many levels in a page-table walk as possible (where a walk is
> needed, because there is no full-length match on the linear address). So, if
> you modify a directory entry from present to not-present, or change the page
> directory that a valid pde points to, you probably need to flush the pde
> caching structure. One piece of good news is that all pde caches are flushed
> by any arbitrary INVLPG.
>   

Hm, but then chapter 10 goes and makes things confusing with 
"Alternative INVLPG Behavior"; but I guess if software needs to 
explicitly enable this behaviour in a yet-to-be-determined way, its OK...

Is there any guide about the tradeoff of when to use invlpg vs flushing 
the whole tlb?  1 page?  10?  90% of the tlb?

    J
