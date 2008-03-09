Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYCIS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYCIS6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYCIS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:58:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYCIS6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:58:45 -0400
Date: Sun, 9 Mar 2008 19:57:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080309185752.GA9548@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org> <20080309115603.GA951@elte.hu> <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
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

> So I would *very* strongly instead argue:
> 
>  - "unsigned long" is the native kernel type for all address manipulation, 
>    and thus "PAGE_SIZE" and "PAGE_MASK" should continue to have that type.
> 
>  - anything that uses any other type without explicitly making sure it's 
>    safe is mis-using those macros. IOW, PAGE_MASk was *never* a type that 
>    had anything what-so-ever to do with page table entry bits, and this is 
>    purely a page table entry issue!
> 
> So my suggested patch would:
> 
>  - make the page table code use a specific mask that it builds up itself, 
>    and makes sure it's of the right type and has the rigth value in 
>    whatever type "struct pte_entry" is. The fact that "pte_val()" is 
>    larger than "unsigned long" on x86-32 is very clearly a PTE issue, 
>    *not* an issue for PAGE_SIZE or PAGE_MASK.

yeah, indeed my patch was sloppy, i didnt think it through - i fell for 
the lure of the easy-looking 'PAGE_SIZE is small, sign-extend it' hack. 

Will do it cleanly and will also clean up all the pte/address/pgprot 
type mixing that currently goes on in this maze of macros.

	Ingo
