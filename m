Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYANW2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYANW2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYANWUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:20:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbYANWUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:20:49 -0500
Date: Mon, 14 Jan 2008 23:23:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080114222349.GA23409@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478BDC43.6050105@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I see the problem.  The problem is that the _PAGE_X defines are 
> defined with _AC(UL, 1 << _PAGE_BIT_X), which has unsigned long type.  
> This means that ~_PAGE_X also has unsigned long type, and so when cast 
> to 64-bit in pte_mkX, it ends up &ing the pte with 0x00000000ffffffxxx, 
> with predictable results.

Actually I fixed some of that -- see the pgtable-nx patch on firstfloor -- but
it still doesn't work. Or maybe my patch was not complete.
> 
> The original code just used signed constants for the _PAGE_X 
> definitions, which will sign-extend when cast to 64-bit, and so have the 
> upper bits set when masking.  (Well, actually, the old code just 
> operated on pte_low, so the problem didn't arise; however, pgtable_64.h 
> also uses integers for its _PAGE_X, which has the same sign-extended 
> 32->64 casting property).
> 
> I'll put together a fixup patch now.

I'm leaving now but can test later.

-Andi
