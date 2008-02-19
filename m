Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYBSHUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYBSHUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYBSHTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:19:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50642 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753650AbYBSHTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:19:53 -0500
Date: Mon, 18 Feb 2008 23:19:48 -0800
From: Jeremy Higdon <jeremy@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Ric Wheeler <ric@emc.com>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219071948.GA244758@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218221644.GN155407@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
> On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
> > First, I still don't understand why in God's sake barriers are "working"
> > while regular cache flushes are not.  Almost no consumer-grade hard drive
> > supports write barriers, but they all support regular cache flushes, and
> > the latter should be enough (while not the most speed-optimal) to ensure
> > data safety.  Why to require write cache disable (like in XFS FAQ) instead
> > of going the flush-cache-when-appropriate (as opposed to write-barrier-
> > when-appropriate) way?
> 
> Devil's advocate:
> 
> Why should we need to support multiple different block layer APIs
> to do the same thing? Surely any hardware that doesn't support barrier
> operations can emulate them with cache flushes when they receive a
> barrier I/O from the filesystem....
> 
> Also, given that disabling the write cache still allows CTQ/NCQ to
> operate effectively and that in most cases WCD+CTQ is as fast as
> WCE+barriers, the simplest thing to do is turn off volatile write
> caches and not require any extra software kludges for safe
> operation.


I'll put it even more strongly.  My experience is that disabling write
cache plus disabling barriers is often much faster than enabling both
barriers and write cache enabled, when doing metadata intensive
operations, as long as you have a drive that is good at CTQ/NCQ.

The only time write cache + barriers is significantly faster is when
doing single threaded data writes, such as direct I/O, or if CTQ/NCQ
is not enabled, or the drive does a poor job at it.

jeremy
