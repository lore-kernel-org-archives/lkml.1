Return-Path: <linux-kernel-owner+w=401wt.eu-S1750956Ab0A2RlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab0A2RlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915Ab0A2RlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:41:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0A2RlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:41:23 -0500
Subject: Re: [PATCH] Add type of locks to lock trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
In-Reply-To: <20100129172939.GD5047@nowhere>
References: <1263799219.4283.0.camel@laptop>
	 <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1264674113.4283.2086.camel@laptop>  <20100129172939.GD5047@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 18:41:05 +0100
Message-ID: <1264786865.24455.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 18:29 +0100, Frederic Weisbecker wrote:

> > I still don't see the use for it, surely you're going to be familiar
> > with the code if you're looking at lock statistics?

> Comparing the avg/max time locks are acquired/waited between same
> types of locks is interesting, but doing so between spinlocks and mutexes
> is definetly pointless. 

Sure, never claimed otherwise, but:
 1) if you're looking at lock behaviour you should also look at the code
    otherwise you have no context to place the contention behaviour in.

 2) exactly because these hold/acquire times differ so much its hard to
    mistake mistake them for anything else.

The concern I have is adding the storage (avoided by not doing it at
init like you suggested) and the event size overhead. Jens' report
confirms that we need to be very careful here, because lock sites are
very high frequent.

So again, _why_? If you're looking at these things its easy (and I'd say
rather crucial) to look up the code.

There simply is no point in looking at these stats if you're not also
going to look at the code. If you're looking at them in a quick
diagnostic way, then the difference against the baseline is important.

