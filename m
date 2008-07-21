Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYGUUHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYGUUHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYGUUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:06:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYGUUGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:06:53 -0400
Date: Mon, 21 Jul 2008 22:05:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080721200554.GA15463@elte.hu>
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI> <20080718091146.GQ6875@elte.hu> <20080721094110.GA16029@elte.hu> <84144f020807210252k68d5cf65i8c7ae3c11cecc046@mail.gmail.com> <20080721100627.GA5953@2ka.mipt.ru> <4884B7C3.9040801@linux-foundation.org> <20080721195748.GA3191@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721195748.GA3191@2ka.mipt.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> It could be an interesting kmemcheck extension to catch not only 
> non-initialized memory, but also writes into just freed one, but not 
> yet returned by allocator to the next user.

hm, i think kmemcheck does that mostly already. If not then I think 
kmemcheck should just turn off all buffering that might happen on the 
SLUB level (if it doesnt do it already). I.e. a kfree()d buffer should 
be marked as uninitialized immediately.

	Ingo
