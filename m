Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXJHCYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXJHCYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 22:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXJHCYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 22:24:32 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:27245 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753002AbXJHCYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 22:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0krbWlX4F8672mrSN6UJrtEGhDL7kN2iHFGNVZOQ6tueZPkUoS2Dqy1lWA17GDqIjphWFkyHW+7ab3kz+nG0Ypq8eqxuXMzGmiCn86yCJgvaHWaK2YyLlkU2Zk+TowVbTECO6gWbX9iKTlu6YTCjzvIPTY2/WyeQuD6lN1jWMSI=  ;
X-YMail-OSG: TK5rW9gVM1nRQbuVOvTukScGgTBTSSAx2yf0d6Eaubc0nWNVaa2p.eoWCSLf5v.904gHx8Iyhg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and pagetable setup/pulldown
Date: Sun, 7 Oct 2007 19:52:29 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickens <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <470596C4.8060804@goop.org> <20071004194432.9b3353c2.akpm@linux-foundation.org>
In-Reply-To: <20071004194432.9b3353c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071952.30192.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 12:44, Andrew Morton wrote:
> On Thu, 04 Oct 2007 18:43:32 -0700 Jeremy Fitzhardinge <jeremy@goop.org> 
wrote:
> > David's change 10a8d6ae4b3182d6588a5809a8366343bc295c20, "i386: add
> > ptep_test_and_clear_{dirty,young}" has introduced an SMP race which
> > affects the Xen pv-ops backend.
>
> y'know, I think I think it's been several years since I saw a report of an
> honest to goodness, genuine SMP race in core kernel.  We used to be
> infested by them, but the term has fallen into disuse.  Interesting, but
> OT.

Does that include data races on weakly ordered systems, or UP races
(ie. with sleeping locks rather than spinning ones)? ;) Because we had
and have a few of those...
