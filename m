Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYCKEIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYCKEIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYCKEIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:08:09 -0400
Received: from n23.bullet.mail.ukl.yahoo.com ([87.248.110.140]:41679 "HELO
	n23.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750811AbYCKEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:08:08 -0400
X-Yahoo-Newman-Id: 629671.46960.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mwuRA9yEfEEiqoo3oSmDKTds8kAK9gLgc0Z+y3101x9UESqINGd/hRxtX9aW+s08/L6F1OVYR/Rc86vi8G1OgmY5oohz8rNbhaL6/pA3nr6GvnBwLwlS5rSGvDByuIOojEH7vCLrAupVJVMGZ6eLPia+FheaFYqVdaSxogALHzM=  ;
X-YMail-OSG: 3cVG4K0VM1mljqd0H2Gq8wfY6w_k57ep1CUIEg..QoDhVvBRbmqLOJXkBJ2Byfmo_HtuI6DycQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: quicklists confuse meminfo
Date: Tue, 11 Mar 2008 15:07:20 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111507.20870.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 02:54, Christoph Lameter wrote:
> On Sun, 9 Mar 2008, Andrew Morton wrote:
> > - They are pretty marginal from a performance POV (iirc)
>
> Pretty significant in our experience.
>
> >   Making __GFP_ZERO smarter/more efficient would be a preferable way of
> >   addressing any performance problems we have in there.
>
> Looking at the page allocator "fastpath": The basic reaons that this was
> such a good optimization was that the page allocator is expensive to call.
> The hotpath gets more and more clogged with logic. Fixing the page
> allocator to be more efficient may be the right approach here. That could
> also include having a list of zeroed pages.

This is insane. We add more and more of this NUMA and cpuset and anti-frag
and page zeroing logic to the page allocator, and then decide that we
don't actually need to obey any of those rules when we're running lat_proc.

You will never be able to make the page allocator faster than a single list
of pages. The reason is because we actually *want* some of these checks and
heuristics in the page allocator.

And I doubt a list of zeroed pages is the right approach. That's just
adding more complexity for lat_proc AFAIKS.


