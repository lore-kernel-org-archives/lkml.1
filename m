Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYHEErP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYHEErP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYHEErA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:47:00 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:41892 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752879AbYHEEq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:46:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jOELNvxaJPMQLnWCwzOZAjCn07rAKCVSOeWR0nEzoH6h53/IgCE4jah21TEmf5E2t6zAKgMrrAEIC3/ai6v2tBELrXmUV0YM8fcg4JUx4Oz/oOtaDjafvRDofIcdA146a9wyCxA12EAa2OoIBFsyPp6/I0SHSN6L3sqFWFFsVEA=  ;
X-YMail-OSG: .MaYj4YVM1moX8aSjJ52Lcc0jULqJeOFGC0DvamMZK6EvPfhkwBk3BHC3DzbUWGdJXj8HSJDYYsxscobxahs_I.Yiu2er160vmZcAaq4fV9MxKz4nWbyLEL1xdQm_5kRUpHpxzDcw2i41OHuw5jdn3pl
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 14:46:52 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051341.53282.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808042106250.3299@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808042106250.3299@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051446.52538.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 14:25, Linus Torvalds wrote:
> On Tue, 5 Aug 2008, Nick Piggin wrote:
> > The part that helps x86 is another patch further down my stack, which
> > can avoid looking at the hashed page waitqueue at unlock_page-time.
> > Basically this eliminates the entire page waitqueue from the cache
> > footprint of fastpath workloads where the lock is uncontended (often:
> > page faulting, write(2), writeout etc).
>
> Hmm. Tell me more. Contention bit?

Exactly. This is around the latest one online from a quick google:

http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/lock-bitops/2.6.22-rc4/mm-unlock-speedup.patch
