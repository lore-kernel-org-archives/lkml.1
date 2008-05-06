Return-Path: <linux-kernel-owner+w=401wt.eu-S1764420AbYEFPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764420AbYEFPcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbYEFPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:32:45 -0400
Received: from gw.goop.org ([64.81.55.164]:51252 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbYEFPco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:32:44 -0400
Message-ID: <48207A13.7010205@goop.org>
Date: Tue, 06 May 2008 16:32:35 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <20080506150432.GA31075@elte.hu> <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> You should have used a pagetable-specific macro, becuse PAGE_MASK is 
> simply fundamentally WRONG, and has absolutely nothing to do with the PFN 
> bits, whether sign-extended or not!
>
> The fact is, the page frane number bits are *not* ~PAGE_MASK or anything 
> like that. They share only the low bits - not the high bits.

Yes.  There's already a PTE_MASK for masking out the PFN vs the flags in 
a pte, but it isn't used consistently (perhaps at all).

    J
