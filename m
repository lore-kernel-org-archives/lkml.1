Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYG1W47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYG1W47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYG1W4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:56:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbYG1W4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:56:51 -0400
Date: Mon, 28 Jul 2008 15:56:51 -0700 (PDT)
Message-Id: <20080728.155651.71572255.davem@davemloft.net>
To: jeremy@goop.org
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <488E4D1C.8000906@goop.org>
References: <20080728.153702.103032029.davem@davemloft.net>
	<488E4D1C.8000906@goop.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 28 Jul 2008 15:50:04 -0700

> David Miller wrote:
> > The triggering event seems to be kstopmachine as done by the first
> > module load.  This seems to create the situation where we do double RQ
> > locking on essentially all the run queues, in order to move the
> > kstopmachine threads around to their proprer cpus.  I think this is
> > what starts to make the lockdep dependency chains huge.
> >   
> 
> Does Rusty's stop_machine rewrite which puts the threads on the correct 
> cpus to start with at least mitigate the symptoms?

I could check that, but it won't keep this from happening
and being triggerable by a trivial userland program setting
scheduler affinities.
