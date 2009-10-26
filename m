Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZJZX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZJZX4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZJZX4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:56:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60468 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbZJZX4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:56:30 -0400
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20091024035438.GY32470@one.firstfloor.org>
References: <1256167297.4768.14.camel@localhost.localdomain>
	 <20091021174804.3885db37@infradead.org>
	 <20091022004919.GT32470@one.firstfloor.org>
	 <20091021194822.72895c46@infradead.org>
	 <20091024035438.GY32470@one.firstfloor.org>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 16:56:20 -0700
Message-Id: <1256601380.4905.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 05:54 +0200, Andi Kleen wrote:
> On Wed, Oct 21, 2009 at 07:48:22PM -0700, Arjan van de Ven wrote:
> > On Thu, 22 Oct 2009 02:49:19 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > you're pretty much the first now who touches ->comm from
> > > > not-the-thread-itself.... are you sure that is safe?
> > > 
> > > It's not, there is no locking. On the other hand nothing should crash,
> > > just users might see half rewritten data.
> > 
> > .. with strings this is tricky though.. if the new string is longer
> > than the old one the terminating zero might just be missed etc.
> 
> Good point.
> He needs to first set the last byte to zero to avoid that.
> But better probably to do a proper lock on all readers. Or not add
> this feature at all (does it have a strong use case?)

Thread naming is really helpful for debugging a large multi-threaded
application. But currently it requires the threads to name themselves. 

In some applications there may be a dispatch thread that spawns off the
siblings, and it has more context for naming the threads then the
threads do themselves.

So in that case, currently in order to have named threads, the
application's dispatch thread assigns names, and the threads have to
occasionally poll to see if they need to name themselves to something.

So they can get it to work, but its ugly and a big pain. Other OSes
support pthread_set_name_np() functionality, which makes things easy for
them, so they've requested to see if Linux can't do something similar.

thanks
-john

