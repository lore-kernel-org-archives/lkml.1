Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbZFOQDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbZFOQDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZFOQDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:03:42 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:52817 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbZFOQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:03:41 -0400
X-Trace: 211656774/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.41.232/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.41.232
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAJMNNkpQKSno/2dsb2JhbAAI1iKEDQU
X-IronPort-AV: E=Sophos;i="4.42,223,1243810800"; 
   d="scan'208";a="211656774"
Date: Mon, 15 Jun 2009 17:02:46 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       torvalds@linux-foundation.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
In-Reply-To: <20090615155228.GA19529@elte.hu>
Message-ID: <Pine.LNX.4.64.0906151700300.9538@sister.anvils>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
 <1245077165.6800.497.camel@laptop> <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
 <1245080486.6800.561.camel@laptop> <20090615155228.GA19529@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> Note that Oprofile uses the same method of __copy_user_inatomic() in 
> arch/x86/oprofile/backtrace.c, but i believe that code is broken - i 
> doubt the call-chain support for user-space stacks ever worked in 
> oprofile - with perfcounters i can make this method crash under 
> load. (we re-enter the NMI which due to IST executes over the exact 
> same, still pending NMI frame. Kaboom.)
> 
> I saw you being involved with the Oprofile code 3 years ago:
> 
> | commit c34d1b4d165c67b966bca4aba026443d7ff161eb
> | Author: Hugh Dickins <hugh@veritas.com>
> | Date:   Sat Oct 29 18:16:32 2005 -0700
> |
> |    [PATCH] mm: kill check_user_page_readable
> 
> That method of __copy_user_inatomic(), while elegant, is subtly 
> wrong in an NMI context. We really must avoid taking faults there.

Yes, I'm afraid that subtlety escaped me - thanks for explaining.

Hugh
