Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbXIHHv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbXIHHv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXIHHu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:50:59 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:38623 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751785AbXIHHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:50:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=D0r/WK4hty5mrDc9yCn5KxNzZITkjytic7Gk5HAlQ8w719VnF0opPh2GbHff5NjrI0bZVhbCsixJqLfi6mYcGeli6sAWTuhVSF5gHURdsGzkvyDGQ6VNQOo3+oQdZB/M/0kdlHWz+9m5RX2hyZJPFuFYWlC6iC8emp+siCmG+NU=  ;
X-YMail-OSG: ko5mBCgVM1nrJlmP8HAYaUwNdzqaRPtDmJps5rOYBl3XP0cdhCmvAjmrmv3RiE_N6KK.767wUHS721s2JOC_N_5rOB7bRxsxbByu
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>, ak@suse.de
Subject: Re: Intel Memory Ordering White Paper
Date: Sun, 9 Sep 2007 03:48:27 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org> <200709090334.27677.nickpiggin@yahoo.com.au>
In-Reply-To: <200709090334.27677.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709090348.28076.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007 03:34, Nick Piggin wrote:
> On Saturday 08 September 2007 09:20, Linus Torvalds wrote:
> > On Sat, 8 Sep 2007, Nick Piggin wrote:
> > > So, can we finally noop smp_rmb and smp_wmb on x86?
> >
> > Did AMD already release their version? If so, we should probably add a
> > commit that does that in somewhat early 2.6.24 rc, and add the pointers
> > to the whitepapers in the commit message.
>
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/245
>93.pdf
>
> AMD64 Architecture Programmer's Manual Volume 2: System Programming
> section 7.2: Multiprocessor Memory Access Ordering, a paragraph on the
> first page says
>
> "Loads do not pass previous loads (loads are not re-ordered). Stores do
> not pass previous stores (stores are not re-ordered)"
>
> So, yes, it should be easy to do.

There is some suggestion in the source code that non-temporal stores
(movntq) are weakly ordered. But AFAIKS from the documents, it is ordered
when operating on wb memory. What's the situation there?

I've also heard that string operations do not follow the normal ordering, but
that's just with respect to individual loads/stores in the one operation, I
hope? And they will still follow ordering rules WRT surrounding loads and
stores?
