Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXL1DXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXL1DXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 22:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXL1DXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 22:23:06 -0500
Received: from waste.org ([66.93.16.53]:48510 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbXL1DXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 22:23:05 -0500
Subject: Re: [patch 00/20] VM pageout scalability improvements
From: Matt Mackall <mpm@selenic.com>
To: Rik van Riel <riel@redhat.com>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com
In-Reply-To: <20071223201149.7b88888f@bree.surriel.com>
References: <20071218211539.250334036@redhat.com>
	 <476D7334.4010301@linux.vnet.ibm.com>
	 <20071222192119.030f32d5@bree.surriel.com>
	 <476EE858.202@linux.vnet.ibm.com>
	 <20071223201149.7b88888f@bree.surriel.com>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 21:20:41 -0600
Message-Id: <1198812041.4406.63.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-23 at 20:11 -0500, Rik van Riel wrote:
> On Mon, 24 Dec 2007 04:29:36 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > Rik van Riel wrote:
> 
> > > In the real world, users with large JVMs on their servers, which
> > > sometimes go a little into swap, can trigger this system.  All of
> > > the CPUs end up scanning the active list, and all pages have the
> > > referenced bit set.  Even if the system eventually recovers, it
> > > might as well have been dead.
> > > 
> > > Going into swap a little should only take a little bit of time.
> > 
> > Very fascinating, so we need to scale better with larger memory.
> > I suspect part of the answer will lie with using large/huge pages.
> 
> Linus vetoed going to a larger soft page size, with good reason.
> 
> Just look at how much the 64kB page size on PPC64 sucks for most
> workloads - it works for PPC64 because people buy PPC64 monster
> systems for the kinds of monster workloads that work well with a
> large page size, but it definately isn't general purpose.

Indeed, machines already exist with >> 1TB of RAM, so even going to 1MB
pages leaves these machines in trouble. Going to big pages a few years
ago would have pushed the problem back a few years, but now we need real
fixes.

-- 
Mathematics is the supreme nostalgia of our time.

