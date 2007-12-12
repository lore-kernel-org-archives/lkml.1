Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbXLLFkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbXLLFkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXLLFk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:40:27 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:22327 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753277AbXLLFk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:40:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wcx+8iqTKiaVV5HSg1ImspGz91o2hLNHelw6XnXNU5d9q+KaSKZcmQW1o7mFila/T4GKzpCHZRA9mYP/qh7ZWmN54q1nd2Lg3K/ZMdXtXaY/XN1CilXW+tAHkmyRDPkFkJmEzqznol6Xy4uAtDxWHc6hqhMyCTQqb+DwR0XR01g=  ;
X-YMail-OSG: nJreVTIVM1nCuhoBmOR149BfxjVneAZXPUIXRUIywcm9xlEzAok4mhdMhNsnbFkMTz0RdO9sjQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [rfc] lockless get_user_pages for dio (and more)
Date: Wed, 12 Dec 2007 16:40:16 +1100
User-Agent: KMail/1.9.5
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ken Chen <kenchen@google.com>, Badari Pulavarty <pbadari@gmail.com>,
       linux-mm <linux-mm@kvack.org>, tony.luck@intel.com,
       Adam Litke <agl@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20071008225234.GC27824@linux-os.sc.intel.com> <200712121557.20807.nickpiggin@yahoo.com.au> <1197436306.6367.12.camel@norville.austin.ibm.com>
In-Reply-To: <1197436306.6367.12.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121640.17077.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 16:11, Dave Kleikamp wrote:
> On Wed, 2007-12-12 at 15:57 +1100, Nick Piggin wrote:
> > On Tuesday 11 December 2007 08:30, Dave Kleikamp wrote:
> > > Nick,
> > > I've played with the fast_gup patch a bit.  I was able to find a
> > > problem in follow_hugetlb_page() that Adam Litke fixed.  I'm haven't
> > > been brave enough to implement it on any other architectures, but I did
> > > add  a default that takes mmap_sem and calls the normal
> > > get_user_pages() if the architecture doesn't define fast_gup().  I put
> > > it in linux/mm.h, for lack of a better place, but it's a little kludgy
> > > since I didn't want mm.h to have to include sched.h.  This patch is
> > > against 2.6.24-rc4. It's not ready for inclusion yet, of course.
> >
> > Hi Dave,
> >
> > Thanks so much. This makes it much more a complete patch (although
> > still missing the "normal page" detection).
> >
> > I think I missed -- or forgot -- what was the follow_hugetlb_page
> > problem?
>
> Badari found a problem running some tests and handed it off to me to
> look at.  I didn't share it publicly.  Anyway, we were finding that
> fastgup was taking the slow path almost all the time with huge pages.
> The problem was that follow_hugetlb_page was failing to fault on a
> non-writable page when it needed a writable one.  So we'd keep seeing a
> non-writable page over and over.  This is fixed in 2.6.24-rc5.

Ah yes, I just saw that fix in the changelog. So not a problem with my
patch as such, but good to get that fixed.


> > Anyway, I am hoping that someone will one day and test if this and
> > find it helps their workload, but on the other hand, if it doesn't
> > help anyone then we don't have to worry about adding it to the
> > kernel ;) I don't have any real setups that hammers DIO with threads.
> > I'm guessing DB2 and/or Oracle does?
>
> I'll try to get someone to run a DB2 benchmark and see what it looks
> like.

That would be great if you could.

Thanks,
Nick
