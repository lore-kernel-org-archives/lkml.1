Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYGGUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYGGUjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYGGUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:39:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:42384 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756392AbYGGUjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:39:08 -0400
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX19t+XxmUbtt7e6E3tTYj0YX5Q9iNVPjM9xkJk14zg
	9JA6bmbVHmWFpA
Subject: Re: [PATCH] rc80211_pid: Fix fast_start parameter handling
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807071331s52dc994ao6ac70e787d88227d@mail.gmail.com>
References: <19f34abd0807070427w5398c617uae0a4e8e40fd8f0e@mail.gmail.com>
	 <1215462228.4416.3.camel@localhost>
	 <19f34abd0807071331s52dc994ao6ac70e787d88227d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 22:39:05 +0200
Message-Id: <1215463145.4416.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 22:31 +0200, Vegard Nossum wrote:
> Hi,
> 
> On Mon, Jul 7, 2008 at 10:23 PM, Mattias Nissler <mattias.nissler@gmx.de> wrote:
> > This removes the fast_start parameter from the rc_pid parameters information
> > and instead uses the parameter macro when initializing the rc_pid state. Since the
> > parameter is only used on initialization, there is no point of making exporting
> > it via debugfs. This also fixes uninitialized memory references to the
> > fast_start and norm_offset parameters.
> >
> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> > ---
> >
> > This should fix the problem. I think this should go into mainline ASAP.
> 
> Was this code actually causing some problem/regression? If so, can we
> please have a reference to bugzilla/prior conversations in the patch
> description?

I think the problem probably didn't cause any major problem at all. At
most, the rate scaling didn't work properly. Maybe the algorithm would
even recover from the incorrect initialization (not too sure about this
one, better ask Stefano about the rate sorting implications). And no, I
have never seen any problem reports that relate to this bug. I wouldn't
call it a regression either, since this is exactly the code that went
mainline with the first version of rc80211_pid.

> 
> Was the reason for the problem known before I posted the "use of
> uninitialized memory" e-mail earlier today? If no, can you please
> sneak in a little reference to kmemcheck there in the patch
> description? The acknowledgement is sorely needed :-)

It was unknown before. Just a sec, I'll post new version of the patch
that mentions kmemcheck ;-)

Mattias

