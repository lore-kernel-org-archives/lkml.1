Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZG0Knq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZG0Knq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZG0Knq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:43:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:54093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZG0Knp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:43:45 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Bill Gatliff <bgat@billgatliff.com>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tommaso Cucinotta <cucinotta@sssup.it>
In-Reply-To: <20090726190343.GB12916@shareable.org>
References: <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
	 <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org>
	 <1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org>
	 <4A6A96AB.7030609@billgatliff.com> <20090725224848.GA15260@shareable.org>
	 <4A6BC2FC.7020700@billgatliff.com>  <20090726190343.GB12916@shareable.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 12:45:45 +0200
Message-Id: <1248691545.6987.1587.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 20:03 +0100, Jamie Lokier wrote:

> So RT-bandwidth would be nice for those threaded interrupts.

No, a different/better scheduling policy would be - maybe.

People mentioned SCHED_SPORADIC, but I really really dislike that
because for the actual sporadic task model we can do so much better
using deadline schedulers.

Furthermore, SCHED_SPORADIC as specified by POSIX is a useless piece of
crap, so we would have to deviate from POSIX, which would create
confusion -- although good documentation might help a little here.

The current RT-bandwidth comes from the RT cgroup code, and its only
purpose in life is to provide isolation between multiple groups through
guaranteeing the bandwidth of others by hard limiting. It does that.

It's certainly not flawless, in fact its not what I would call complete
(hence its still EXPERIMENTAL status), but Fabio is working on
implementing a deadline H-CBS for this, which would greatly improve the
situation.

Extending the deadline model with a soft mode might be useful as
mentioned by Tommaso, but I would only be looking at that after we've
completed work on the normal deadline bits (both group and task). And
then we'd have to consistently and full integrate it with both.

