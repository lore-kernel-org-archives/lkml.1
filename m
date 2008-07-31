Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYGaHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYGaHOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYGaHOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:14:14 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:36219 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752423AbYGaHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:14:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FjlJS3oAwoovbd9vN65L+VmrGfpC2CpXvQ+YsNPJZ2McqJnwatYr7lnNXZ0FjACz5txzajfkegSthnXs+vNkf2gJkU35zn9ZTzrMNcSXarNpIBs02xGiHOIwNJyPz/8GDPTavmUWbBfGVYOPVMRXkLq0AjU/Qzpe7d1DZSke0Yo=  ;
X-YMail-OSG: Ig.H_KQVM1mPLae8N151oD1fvxi7w9l3inAJz21cm3813B.yg1S2sH2F3ub9n4T4H1GMoHR1.Ime.vnYXDaD_iFMBSD2ZJ41pf359j3EEcRzwSjoJeklNXdwQrDlbFzOC6s-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Holt <holt@sgi.com>
Subject: Re: GRU driver feedback
Date: Thu, 31 Jul 2008 17:14:04 +1000
User-Agent: KMail/1.9.5
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080723141229.GB13247@wotan.suse.de> <20080729185315.GA14260@sgi.com> <200807301550.34500.nickpiggin@yahoo.com.au>
In-Reply-To: <200807301550.34500.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311714.05252.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 15:50, Nick Piggin wrote:
> On Wednesday 30 July 2008 04:53, Robin Holt wrote:

> > In the case where unmap_region is clearing page tables, the caller to
> > unmap_region is expected to be holding the mmap_sem writably.  Jacks
> > fault handler will immediately return when it fails on the
> > down_read_trylock().
>
> No, you are right of course. I had in my mind the problems faced by
> lockless get_user_pages, in which case I was worried about the page table
> existence, but missed the fact that you're holding mmap_sem to provide
> existence (which it would, as you note, although one day we may want to
> reclaim page tables or something that doesn't take mmap_sem, so a big
> comment would be nice here).

The other thing is... then GRU should get rid of the local_irq_disable
in the atomic pte lookup. By definition it is worthless if we can be
operating on an mm that is not running on current (and if I understand
correctly, sn2 can avoid sending tlb flush IPIs completely sometimes?)
