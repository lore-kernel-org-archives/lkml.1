Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYD2RFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYD2RFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYD2RE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:04:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYD2RE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:04:57 -0400
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <e2e108260804290929l3c7a6a07nddc18512abb9e6ed@mail.gmail.com>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
	 <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
	 <1209485739.13978.96.camel@twins>
	 <e2e108260804290929l3c7a6a07nddc18512abb9e6ed@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 19:04:03 +0200
Message-Id: <1209488643.6433.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 18:29 +0200, Bart Van Assche wrote:
> On Tue, Apr 29, 2008 at 6:15 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >  > Or: whether or not to allow a sequence like "rlock(a); rlock(b);
> >  > runlock(b); runlock(a); rlock(b); rlock(a);" is something we can
> >  > choose. We do not have to forbid this sequence -- we can choose
> >  > whether or not we allow this sequence.
> >
> >  I'm utterly confused now; I never argued that it would get deadlocks;
> >  and I said I choose to not allow it from a lockdep pov. What else do you
> >  want?
> 
> So we both agree that the statement in the original e-mail (by Gautham
> R Shenoy) is wrong ? The original e-mail stated that obtaining reader
> locks in an inconsistent order is wrong.

I think the critical part is:

> It really is invalid when considered against write locks.

Aside from that it just states that inversion of lock order will be
treated as invalid - even for read locks.



