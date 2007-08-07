Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbXHGFNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbXHGFNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 01:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXHGFNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 01:13:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbXHGFNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 01:13:45 -0400
Date: Mon, 6 Aug 2007 22:12:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: Andi Kleen <ak@suse.de>, Lee.Schermerhorn@hp.com, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
Message-Id: <20070806221252.aa1e9048.akpm@linux-foundation.org>
In-Reply-To: <20070806215541.GC6142@skynet.ie>
References: <20070802172118.GD23133@skynet.ie>
	<200708040002.18167.ak@suse.de>
	<20070806121558.e1977ba5.akpm@linux-foundation.org>
	<200708062231.49247.ak@suse.de>
	<20070806215541.GC6142@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 22:55:41 +0100 mel@skynet.ie (Mel Gorman) wrote:

> On (06/08/07 22:31), Andi Kleen didst pronounce:
> > 
> > > If correct, I would suggest merging the horrible hack for .23 then taking
> > > it out when we merge "grouping pages by mobility".  But what if we don't do
> > > that merge?
> > 
> > Or disable ZONE_MOVABLE until it is usable?
> 
> It's usable now. The issue with policies only occurs if the user specifies
> kernelcore= or movablecore= on the command-line. Your language suggests
> that you believe policies are not applied when ZONE_MOVABLE is configured
> at build-time.

So..  the problem which we're fixing here is only present when someone
use kernelcore=.  This is in fact an argument for _not_ merging the
horrible-hack.

How commonly do we expect people to specify kernelcore=?  If "not much" then
it isn't worth adding the __alloc_pages() overhead?

(It's a pretty darn small overhead, I must say)
