Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYKRKHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYKRKHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 05:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYKRKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 05:07:21 -0500
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:33373 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751356AbYKRKHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:07:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3XhkeHuCiqcpX3uxPFYXDZw/KlI1SlJt67LVHkZl98CPWQKf7nYOe4RQCyQ7jkkE2M26sZuYxPEOspe3JoBeNUUzRi148lIkODshJK9vrc3DDW74JuXpZGgXNT8lwkA0PS6lJXzJmkCYPVXtyuW+t/RxXlPGCk2ppYKvHroexvc=  ;
X-YMail-OSG: xcQodJ4VM1k1mM7OsHTEJSQTC78vvQKIK0XMQwDTcLCtJToS8TXikkWYPJqGpRmXtXNndzF1F0srT0HC5KwUXfkuL783dO0YQbqDwk5a.oDXaKqNZnRDm1lmFDQOrFYbnUO3ycEiIaVaHEfJt7paMJyXLt.t1GuJ6SgMt9MW
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: Large stack usage in fs code (especially for PPC64)
Date: Tue, 18 Nov 2008 21:07:12 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org> <18721.62958.479215.822513@cargo.ozlabs.ibm.com>
In-Reply-To: <18721.62958.479215.822513@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182107.12747.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 09:53, Paul Mackerras wrote:

> I'd love to be able to use a 4k base page size if I could still get
> the reduction in page faults and the expanded TLB reach that we get
> now with 64k pages.  If we could allocate the page cache for large
> files with order-4 allocations wherever possible that would be a good
> start.

That can still have nasty side-effects like fragmentation and 64k
granular reclaim. It also adds complexity to mapping the pages to
userspace.

Christoph's patchset IIRC also only did page cache, wheras I suppose
your kernbench workload is gaining mainly from anonymous page faults.
