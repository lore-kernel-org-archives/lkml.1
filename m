Return-Path: <linux-kernel-owner+w=401wt.eu-S1764415AbYD2O5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764415AbYD2O5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYD2O5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:57:35 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:51267 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYD2O5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:57:34 -0400
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
In-Reply-To: <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 16:57:30 +0200
Message-Id: <1209481050.13978.72.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 15:16 +0200, Bart Van Assche wrote:
> On Tue, Apr 29, 2008 at 2:57 PM, Gautham R Shenoy <ego@in.ibm.com> wrote:
> > Subject: lockdep: fix recursive read lock validation
> >  This means that the following sequence is now invalid, whereas previously
> >  it was considered valid:
> >
> >   rlock(a); rlock(b); runlock(b); runlock(a)
> >   rlock(b); rlock(a);
> 
> Why are you marking this sequence as invalid ? Although it can be
> debated whether it is good programming practice to be inconsistent
> about the order of read-locking, the above sequence can't be involved
> in a deadlock.

Not for pure read locks, but when you add write locks to it, it does get
deadlocky. Lockdep does not keep separate chains for read and write
locks.

