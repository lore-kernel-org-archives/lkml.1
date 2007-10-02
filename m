Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbXJCIwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbXJCIwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXJCIws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:52:48 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:36848 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751777AbXJCIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:52:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uqbiRrso3SrtSmHlUFTjmVEPaHNRSlQIEytdOLdCKBq4mn5Z7VV9sUyXjYRfoNT4rAjdipJzcaZOfXK63y51nwMawRwm05ITsBzjMa0ol8nRQ7op//eDSfDwxcnpcIwTQ8mKBqg834rgBx1onayMhmgNc0bnBv5IQX2mNtmHRMo=  ;
X-YMail-OSG: k2aMnHMVM1nnj.qjUGX9CAT9AukJ.Abe1..OfKC_suPM3_aPoA220Tkha8gnQ9ISkwkyC0zpMxrYJPDhSevgpuRSgw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Wed, 3 Oct 2007 02:14:48 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200710022335.05357.nickpiggin@yahoo.com.au> <20071003002555.045bea2a.pj@sgi.com>
In-Reply-To: <20071003002555.045bea2a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030214.49026.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 17:25, Paul Jackson wrote:
> Nick wrote:
> > BTW. as far as the sched.c changes in your patch go, I much prefer
> > the partition_sched_domains API: http://lkml.org/lkml/2006/10/19/85
> >
> > The caller should manage everything itself, rather than
> > partition_sched_domains doing half of the memory allocation.
>
> Please take a closer look at my partition_sched_domains() and its
> interface to the scheduler.
>
> You should recognize this API, once you look at it.  It simply passes
> the full flat, hard partition, in its entirety.  This is the
> partitioning that you speak of, I believe.  It's here; just not where
> you expected it.
>
> The portion of the code that is in kernel/sched.c is just a little bit
> of optimization.  It avoids rebuilding all the sched domains and
> reattaching every task to its sched domain; rather it determines which
> sched domains were added or removed and just rebuilds them.
>
> Once you take a closer look, I hope you will agree that this new
> interface between the cpuset and sched code provides a cleaner
> separation.

I don't know what you think I said that is incorrect and requires me to
look at again. I don't like your partition_sched_domains API because
of the allocation thing. So I prefer the existing (or better, the simplified
version in my patch referenced).

The caller should determine which domain to rebuild and reattach.
Simple.
