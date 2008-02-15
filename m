Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbYBOHas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbYBOHas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764578AbYBOHak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:30:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764250AbYBOHaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:30:39 -0500
Date: Fri, 15 Feb 2008 08:30:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080215073026.GA25583@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com> <alpine.LFD.1.00.0802142139260.4255@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802142139260.4255@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So *if* we care (I doubt we do, since EFI_PAGE_SHIFT at least right 
> now matches PAGE_SHIFT on x86), you'd probably want to do something 
> like
> 
>   static inline unsigned long efi_pages_to_native_pages(unsigned long efi_pages)
>   {
>   #if EFI_PAGE_SHIFT > PAGE_SHIFT
> 	return efi_pages << (EFI_PAGE_SHIFT - PAGE_SHIFT);
>   #else
> 	return efi_pages >> (PAGE_SHIFT - EFI_PAGE_SHIFT);
>   #endif
>   }

yeah, this is even cleaner - i guess EFI_PAGE_SHIFT will be around in 
the future too because it's also used on ia64.

	Ingo
