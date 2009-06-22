Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZFVQIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZFVQIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZFVQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:07:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48330 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZFVQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:07:52 -0400
Date: Mon, 22 Jun 2009 09:07:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Message-ID: <20090622160753.GE6754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090506225115.GM6771@linux.vnet.ibm.com> <20090506112459.5edd0902.akpm@linux-foundation.org> <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com> <20090506120909.GR25203@elte.hu> <11979.1241648574@redhat.com> <26931.1245670998@redhat.com> <20090622124951.GB30553@elte.hu> <20090622082941.c5c8b3f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622082941.c5c8b3f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 08:29:41AM -0700, Andrew Morton wrote:
> On Mon, 22 Jun 2009 14:49:51 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * David Howells <dhowells@redhat.com> wrote:
> > 
> > > Hi Paul,
> > > 
> > > Are you going to push your RCU patch for this merge window?
> > 
> > Andrew needs to be convinced for that to happen.
> > 
> 
> whome?  I rarely have firm opinions on anything.  iirc the question
> here was "is it worth adding another RCU implementation to save 900
> bytes"?
> 
> I find it pretty hard to see how to come up with "yes" for that one but
> it's hardly a huge issue.  If you guys feel otherwise then go wild.

Well, I do need to pull the "expedited" interface into the bloatwatch
version, and my update of rcutorture made me realize that I can cut
out a few more bytes, so I will submit an update.  For what it is worth,
here are the opinions expressed on LKML:

+	Ingo Molnar: good documentation, minimal RCU implementation.
?	Andi Kleen: will there be !SMP systems in the future?
+	Lennert Buytenhek: there will be !SMP ARM for a long time.
+	Paul Mundt: good idea for more-constrained SH platforms.
+	David Howells: Acked-by.  works on FRV board.
?	Andrew Morton: do we really need another RCU implementation?

Of course, I well remember programming systems with 4K of core memory
back in the 1970s, and therefore feel a bit guilty about sticking deep
embedded platforms with the increase in memory footprint represented
by Hierarchical RCU compared to Classic RCU.  And Bloatwatch RCU is much
smaller and easier to understand/maintain than is Classic RCU.

So, again, I will forward port, optimize, test, and resubmit.

							Thanx, Paul
