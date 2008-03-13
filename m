Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYCMR4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYCMR4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYCMR4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:56:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32938 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbYCMR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:56:18 -0400
Subject: Re: BUG: lock held when returning to user space
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Frank Munzert <frankm@linux.vnet.ibm.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1205429946.8514.255.camel@twins>
References: <47D7FAA0.1090802@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0803122236030.7266@twin.jikos.cz>
	 <1205423029.10894.75.camel@localhost.localdomain>
	 <1205429946.8514.255.camel@twins>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 10:56:14 -0700
Message-Id: <1205430974.10894.86.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 18:39 +0100, Peter Zijlstra wrote:

> > These need to be removed, but the usage is clearly not compatible with
> > the mutex API ..
> > 
> > If you convert them to atomic counts then you loose the sleeping aspect
> > of the semaphore, which you'd have to add back somehow.
> > 
> > The only API that seems straight forward is using complete's .. Then you
> > get an atomic count and all the sleeping function calls you might want..
> > (include/linux/completion.h) The problem with complete's is that you
> > can't start them out at "1" or "completed" unless you actually run
> > complete() once during initialization (that's kind of ugly) ..
> 
> A simple waitqueue would work.

I was just mulling over what the most straight forward way would be.. I
thought about wait queues, but the API didn't seem as easy to use a
completes..

Daniel

