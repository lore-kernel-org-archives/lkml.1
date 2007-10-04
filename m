Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXJDQyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXJDQyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbXJDQyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:54:25 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49182 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbXJDQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:54:24 -0400
Date: Thu, 4 Oct 2007 17:53:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: gurudas pai <gurudas.pai@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
In-Reply-To: <alpine.LFD.0.999.0710040920400.23684@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710041741250.24671@blonde.wat.veritas.com>
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au>
 <200710040139.04201.nickpiggin@yahoo.com.au> <4704BA1F.4070408@oracle.com>
 <Pine.LNX.4.64.0710041647090.17987@blonde.wat.veritas.com>
 <alpine.LFD.0.999.0710040920400.23684@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Linus Torvalds wrote:
> 
> Ouch.

Very much so.

> 
> The patch looks obviously correct, to the point that I don't understand 
> how this bug happened in the first place.  It seems to have been 
> introduced by Nick in d0217ac04ca6591841e5665f518e38064f4e65bd ("mm: fault 
> feedback #1") if I read it right.

Yes, I think you are reading that right.

> 
> So "do_nonlinear_fault()" would effectively end up unmapping the PTE 
> twice, right? And if I understand the problem right, this wasn't noticed 
> immediately, because it probably only matters on:
> 
>  - CONFIG_HIGHPTE
> *and*
>  - a filesystem that allows VM_NONLINEAR, which became very rare with 
>    dirty accounting.
> 
> Correct?

Correct.  And though I eventually realized the nonlinear dirty accounting
issue (which I did highlight in the patch comment), I'd forgotten all
about needing CONFIG_HIGHPTE in addition to CONFIG_HIGHMEM - yes, that
increased the probability of overlooking it too.

No excuses that we did miss it in all these months those patches have
been around; but it's an object lesson in the trouble rare paths give.

Hugh
