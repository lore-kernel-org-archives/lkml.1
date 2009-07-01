Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZGAE0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZGAE0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZGAEZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:25:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:8316 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZGAEZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IvOFaGiOdzjftU9/lPb4mDvg4YMhtAEtoOh0L242C4RGM3l/SwMTsM7H6spg2jSHRd
         QwQ4jnuLwsN6R4HAisZbxKTcykAg4EI4BPUwVcdhcrMevaWmGXvfkcj4eVvPCnPaFX8m
         u582HH1+pQyFt45GI6KtMB5JAZApqPSI9ekUg=
Date: Wed, 1 Jul 2009 12:25:54 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090701042554.GA14344@localhost>
References: <4A4AD07E.2040508@redhat.com> <20090701040649.GA12832@localhost> <20090701131734.85D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701131734.85D9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 01:18:39PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Jun 30, 2009 at 10:57:02PM -0400, Rik van Riel wrote:
> > > KOSAKI Motohiro wrote:
> > >
> > >>> [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
> > >>> [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
> > >>> [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
> > >>> [ 1522.019262]  isolate:69817
> > >>
> > >> OK. thanks.
> > >> I plan to submit this patch after small more tests. it is useful for OOM analysis.
> > >
> > > It is also useful for throttling page reclaim.
> > >
> > > If more than half of the inactive pages in a zone are
> > > isolated, we are probably beyond the point where adding
> > > additional reclaim processes will do more harm than good.
> > 
> > There are probably more problems in this case. For example,
> > followed is the vmstat after first (successful) run of msgctl11.
> > 
> > The question is: Why kswapd reclaims are absent here?
> 
> if direct reclaim isolate all pages, kswapd can't reclaim any pages.

OOM will occur in that condition. What happened before that time?

> I believe Rik's idea solve this problem.

Me too :)

Thanks,
Fengguang

