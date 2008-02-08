Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbYBHLJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbYBHLJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbYBHLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:09:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbYBHLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:09:12 -0500
Date: Fri, 8 Feb 2008 12:44:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080208114419.GB4745@one.firstfloor.org>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org> <20080207203705.GA19083@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207203705.GA19083@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> because it's not just an open-coded __tlb_flush_all(), it _disables PGE 
> and keeps it so while the MTRR's are changed on all CPUs_.

Yes and? 

> 
> Your patch adds __flush_tlb_all() which re-enables the PGE bit in cr4, 
> see asm-x86/tlbflush.h:
> 
>         /* clear PGE */
>         write_cr4(cr4 & ~X86_CR4_PGE);
>         /* write old PGE again and flush TLBs */
>         write_cr4(cr4);
> 
> so we'll keep PGE enabled during the MTRR setting - which changes 
> behavior.

It changes behaviour in some minor ways but I don't think it makes any 
difference. PGE only influences TLB flushes (according to its 
specification) and all the TLB flushes still run with PGE disabled.

-Andi

