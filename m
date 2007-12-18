Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXLRGAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXLRGAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXLRGAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:00:22 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:50863 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbXLRGAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:00:16 -0500
Date: Tue, 18 Dec 2007 01:00:15 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Picco, Robert W." <robert.picco@hp.com>,
       "tony.luck@intel.com" <tony.luck@intel.com>
Subject: Re: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating memory
Message-ID: <20071218060015.GE16467@fattire.cabal.ca>
References: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net> <20071218100545.14ae2c73.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218100545.14ae2c73.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:05:45AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 13 Dec 2007 15:03:07 +0000
> 
> > +       if (mm != active_mm) {
> > +               /* Restore region IDs for mm */
> > +               if (mm && active_mm) {
> > +                       activate_context(mm);
> > +               } else {
> > +                       flush_tlb_all();
> > +                       return;
> > +               }
> >         }
> should be 
> 

platform_global_tlb_purge is already (and afaict, only) called under
preempt_disable already. then again, the sn2 global_tlb_purge
does it, so possibly for completeness sake it should be added here as
well?

regards, kyle
