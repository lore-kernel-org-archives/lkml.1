Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYBRWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYBRWRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYBRWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:17:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752826AbYBRWRG (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:17:06 -0500
Date: Tue, 19 Feb 2008 09:16:44 +1100
From: David Chinner <dgc@sgi.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ric Wheeler <ric@emc.com>, device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080218221644.GN155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B9870B.8060005@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
> First, I still don't understand why in God's sake barriers are "working"
> while regular cache flushes are not.  Almost no consumer-grade hard drive
> supports write barriers, but they all support regular cache flushes, and
> the latter should be enough (while not the most speed-optimal) to ensure
> data safety.  Why to require write cache disable (like in XFS FAQ) instead
> of going the flush-cache-when-appropriate (as opposed to write-barrier-
> when-appropriate) way?

Devil's advocate:

Why should we need to support multiple different block layer APIs
to do the same thing? Surely any hardware that doesn't support barrier
operations can emulate them with cache flushes when they receive a
barrier I/O from the filesystem....

Also, given that disabling the write cache still allows CTQ/NCQ to
operate effectively and that in most cases WCD+CTQ is as fast as
WCE+barriers, the simplest thing to do is turn off volatile write
caches and not require any extra software kludges for safe
operation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
