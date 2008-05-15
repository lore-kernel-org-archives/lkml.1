Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYEORFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYEORFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYEORFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:05:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39381 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbYEORFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:05:40 -0400
Date: Thu, 15 May 2008 10:05:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <1210822002.3177.121.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> 
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> 
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> 
 <482B2617.5010605@firstfloor.org>  <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-988906689-1210871135=:18354"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-988906689-1210871135=:18354
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 15 May 2008, Zhang, Yanmin wrote:

> > It can thrash cachelines if objects from the same slab page are freed=
=20
> > simultaneously on multiple processors. That occurred in the hackbench=
=20
> > regression that we addressed with the dynamic configuration of slab siz=
es.
> hackbench regression is because of slow allocation instead of slow freein=
g.
> With =FF=FFdynamic configuration of slab sizes, fast allocation becomes 9=
7% (the bad
> one is 68%), but fast free is always 8~9% with/without the patch.

Thanks for using the slab statistics. I wish I had these numbers for the=20
TPC benchmark. That would allow us to understand what is going on while it=
=20
is running.

The frees in the hackbench were slow because partial list updates occurred=
=20
to frequently. The first fix was to let slab sit longer on the partial=20
list. The other was the increase of the slab sizes which also increases=20
the per cpu slab size and therefore the objects allocatable without a=20
round trip to the page allocator. Freeing to a per cpu slab never requires=
=20
partial list updates. So the frees also benefitted from the larger slab=20
sizes. But the effect shows up in the count of partial list updates not in=
=20
the fast/free collumn.


---1700579579-988906689-1210871135=:18354--
