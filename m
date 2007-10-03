Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXJDIKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXJDIKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 04:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbXJDIKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 04:10:41 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39467 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752252AbXJDIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:10:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yD1vlO1f8vMsnon490SD65cE6FrHa56RHTm1bghHFztTcbRN0yFCJsD7aVl9ZpIuhiCsiCX7NN7UonVIqFV+Y/UN3GoQzGvZGN+fR0TJMHXIe/ix+z+Eywby42P4o7gLR/LoKrOyQhWbH0mde+5mTPolD+q3Ll+GZFysyVpBptk=  ;
X-YMail-OSG: 0ZH4qLAVM1kpL.LwyO1po3h_bskf72lO8P8R9VYpmItUYqYCGHlmGvpAHYgn..cgoBpSmcvAgw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: gurudas pai <gurudas.pai@oracle.com>
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
Date: Thu, 4 Oct 2007 01:39:04 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au>
In-Reply-To: <200710040053.19570.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710040139.04201.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 00:53, Nick Piggin wrote:
> On Thursday 04 October 2007 16:37, gurudas pai wrote:
> > Hi,
> >
> > While running Oracle database test on x86/6GB RAM machine panics with
> > following messages.
>
> Hi,
>
> Hmm, seems like something in sys_remap_file_pages might have broken.
> It's a bit hard to work out from the backtrace, though.
>
> Is it possible you can strace to find the arguments for the
> remap_file_pages that goes wrong?

Ahh, I think it's just underflowing the preempt count somewhere, which
is leading highmem.c:15 to just *think* it is in an interrupt.

But you aren't running a preemptible kernel, which makes it unusual...
it would have to be coming from interrupt code (or just random corruption).
Still, preempt debugging should catch those cases as well.

So, can you disregard my last message, and instead compile a kernel
with CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT, and see what
messages come up?

Thanks,
Nick
