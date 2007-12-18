Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbXLRGXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbXLRGXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXLRGXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:23:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38311 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXLRGXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:23:45 -0500
Date: Tue, 18 Dec 2007 15:26:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Picco, Robert W." <robert.picco@hp.com>,
       "tony.luck@intel.com" <tony.luck@intel.com>
Subject: Re: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating
 memory
Message-Id: <20071218152642.4761ae4a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071218060015.GE16467@fattire.cabal.ca>
References: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
	<20071218100545.14ae2c73.kamezawa.hiroyu@jp.fujitsu.com>
	<20071218060015.GE16467@fattire.cabal.ca>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 01:00:15 -0500
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Tue, Dec 18, 2007 at 10:05:45AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 13 Dec 2007 15:03:07 +0000
> > 
> > > +       if (mm != active_mm) {
> > > +               /* Restore region IDs for mm */
> > > +               if (mm && active_mm) {
> > > +                       activate_context(mm);
> > > +               } else {
> > > +                       flush_tlb_all();
> > > +                       return;
> > > +               }
> > >         }
> > should be 
> > 
> 
> platform_global_tlb_purge is already (and afaict, only) called under
> preempt_disable already. then again, the sn2 global_tlb_purge
> does it, so possibly for completeness sake it should be added here as
> well?
> 
Thank you. I see. flush_tlb_range() is the only caller.

...maybe adding comment is helpful (for me :).

Thanks,
-Kame

