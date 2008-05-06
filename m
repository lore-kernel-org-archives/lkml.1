Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYEFPLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYEFPLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYEFPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:10:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYEFPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:10:53 -0400
Date: Tue, 6 May 2008 08:09:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Hugh Dickins <hugh@veritas.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <20080506150432.GA31075@elte.hu>
Message-ID: <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <20080506150432.GA31075@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Ingo Molnar wrote:
> 
> hm, the main objection was about whether to turn PAGE_SIZE from unsigned 
> into signed though - and that we didnt do.

No it wasn't.

The main objection was that you SHOULD NOT USE PAGE_SIZE_MASK AT ALL!

You should have used a pagetable-specific macro, becuse PAGE_MASK is 
simply fundamentally WRONG, and has absolutely nothing to do with the PFN 
bits, whether sign-extended or not!

The fact is, the page frane number bits are *not* ~PAGE_MASK or anything 
like that. They share only the low bits - not the high bits.

			Linus
