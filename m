Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYH1U2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYH1U2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYH1U2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:28:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43873 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYH1U2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:28:37 -0400
Date: Thu, 28 Aug 2008 13:28:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
Message-ID: <20080828202832.GF6750@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080827173950.02afc804@lxorguk.ukuu.org.uk> <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk> <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <21723.1219847044@redhat.com> <4235.1219915184@redhat.com> <20080828104503.68f42b28@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828104503.68f42b28@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 10:45:03AM +0100, Alan Cox wrote:
> On Thu, 28 Aug 2008 10:19:44 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > > We get a number of things:
> > > > 
> > > >  (1) Multiple credential changes all happen simultaneously (setresuid() for
> > > >      example).  The new set of credentials is committed with a single RCU
> > > >      assignment.
> > > 
> > > Makes sense - except for the question of bounding memory utilisation.
> > 
> > Would it make sense to call synchronise_rcu() from commit_creds() or from
> > setuid()/setresuid()/setgroups()/etc. to make sure that some user process
> > doing:
> > 
> > 	while (1)
> > 		alter_credentials();
> > 
> > doesn't run the system out of memory by having loads of frees waiting in RCU's
> > queues because put_cred() uses call_rcu() to defer the destruction.
> 
> I suspect you to - or every "nth" event - building up a small queue as
> would occur in normal usage probably isn't a problem.

Makes sense to me, given that we should not expect real-time determinism
out of alter_credentials().  ;-)

							Thanx, Paul
