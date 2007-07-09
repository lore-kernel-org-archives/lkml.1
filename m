Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXGITns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXGITns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXGITnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:43:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbXGITnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:43:40 -0400
Date: Mon, 09 Jul 2007 12:43:59 -0700 (PDT)
Message-Id: <20070709.124359.38710002.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707090845230.13792@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com>
	<20070707.213752.63129539.davem@davemloft.net>
	<Pine.LNX.4.64.0707090845230.13792@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Mon, 9 Jul 2007 08:45:42 -0700 (PDT)

> On Sat, 7 Jul 2007, David Miller wrote:
> 
> > From: Christoph Lameter <clameter@sgi.com>
> > Date: Sat, 07 Jul 2007 20:49:52 -0700
> > 
> > > A cmpxchg is less costly than interrupt enabe/disable
> > 
> > This is cpu dependant, and in fact not true at all on Niagara
> > and several of the cpus in the UltraSPARC family.
> 
> Hmmm... So have alternate aloc/free paths depending on the cpu?

As Andi seemed to imply I don't even think cmpxchg is faster than
interrupt enable/disable on current generation AMD x86_64 chips, so
are you targetting this optimization solely at Intel x86 Core Duo
32-bit chips?  That's the only one I can see which will benefit from
this.  Are you going to probe the cpu sub-type and patch SLUB?

I really don't think this optimization is wise as even if you
could decide at build time, it's going to be a maintainence and
debugging nightmare to have to field bug reports given two different
locking schemes.

Please reconsider this change, thanks.

