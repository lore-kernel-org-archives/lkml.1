Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZASInX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZASInX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZASInM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:43:12 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:35418 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752630AbZASInL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:43:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AFuFKY5+bbHXwaGqsxNJgotX6CrJYu2xKvDv5+4pCM4c2poCVMSAsx7Y8kX3JXoVmUEAS1aetwJDGQ3zl4YqBELLhwdjp/jLIh3RsVpk8MrsA7e5q/1j2cXCfeMq2Q++GqOosUKuab0PhB+kAZg7swmBO0pfiJJ/xm0qbnWiXWA=  ;
X-YMail-OSG: txNbOpIVM1njJkguDlhlTmSmu5OZhnGGBgDF5efu84ueizDjUq3pgaRY5lJym6Xq0Najjz0jnc0hA7.xZOkRKKTWaH_ZGNFOWHZ09N34jCNTnHTc4Eul3PzUbMUkvWYy9KLN5mR.kY.5NY528U3w2mtxHvRUVSwbZElWG4vhP1Ihara1tQs2d3KfgQOxHQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 19:42:47 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <1232352303.30141.25.camel@penberg-laptop> <200901191933.29322.nickpiggin@yahoo.com.au>
In-Reply-To: <200901191933.29322.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191942.48548.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009 19:33:27 Nick Piggin wrote:
> On Monday 19 January 2009 19:05:03 Pekka Enberg wrote:

> > All I am saying is that I don't like how we're fixing a performance bug
> > with a shiny new allocator without a credible explanation why the
> > current approach is not fixable.
>
> To be honest, my biggest concern with SLUB is the higher order pages
> thing. But Christoph always poo poos me when I raise that concern, and
> it's hard to get concrete numbers showing real fragmentation problems
> when it can take days or months to start biting.
>
> It really stems from queueing versus not queueing I guess. And I think
> SLUB is flawed due to its avoidance of queueing.

And FWIW, Christoph was also not able to fix the OLTP problem although
I think it has been known for nearly two years ago now (I remember we
talked about it at 2007 KS, although I wasn't following slab development
very keenly back then).

At this point I feel spending time working on SLUB isn't a good idea if
a) Christoph himself hadn't fixed this problem; and b) we disagree about
fundamental design choices (see the "SLQB slab allocator" thread).

Anyway, nobody has disagreed with my proposal to merge SLQB, so in the
worst case I don't think it will cause too much harm, and in the best
case it might turn out to make the best tradeoffs and who knows, it
might actually not be catastrophic for HPC ;)

